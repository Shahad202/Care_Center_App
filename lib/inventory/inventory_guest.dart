import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_detail.dart';

class UserInventoryWidget extends StatefulWidget {
  @override
  State<UserInventoryWidget> createState() => _UserInventoryWidgetState();
}

class _UserInventoryWidgetState extends State<UserInventoryWidget> {
  late TextEditingController _searchController;

  String _selectedStatus = 'All';
  String _sortBy = 'A-Z';
  bool _isGridView = false;

  final CollectionReference inventoryRef = FirebaseFirestore.instance
      .collection('inventory');

  final List<String> _statusOptions = [
    'All',
    'Available',
    'Rented',
    'Donated',
    'Maintenance',
  ];

  final Map<String, IconData> itemIcons = {
    'wheelchair': Icons.wheelchair_pickup,
    'walker': Icons.accessibility_new,
    'crutches': Icons.elderly,
    'oxygen machine': Icons.medical_services,
    'hospital bed': Icons.bed,
    'other': Icons.inventory_2,
  };

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<QueryDocumentSnapshot> _applyFilters(List<QueryDocumentSnapshot> items) {
    final query = _searchController.text.toLowerCase();

    var filtered = items.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final String name = data['name'] ?? '';
      final String type = data['type'] ?? 'other';
      final String category = data['category'] ?? '';
      final String status = data['status'] ?? '';
      final String location = data['location'] ?? '';
      final String quantity = data['quantity'].toString();
      final String description = data['description'] ?? '';
      final String condition = data['condition'] ?? '';
      final String rentalPrice = data['price'] ?? '0.000';
      final List<String> tags = List<String>.from(data['tags'] ?? []);
      final matchesSearch = name.contains(query) || category.contains(query);

      final matchesStatus =
          _selectedStatus == 'All' || status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    if (_sortBy == 'A-Z') {
      filtered.sort((a, b) {
        final an = (a['name'] ?? '').toString();
        final bn = (b['name'] ?? '').toString();
        return an.compareTo(bn);
      });
    } else {
      filtered.sort((a, b) {
        final an = (a['name'] ?? '').toString();
        final bn = (b['name'] ?? '').toString();
        return bn.compareTo(an);
      });
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF155DFC),
        title: const Text('Inventory'),
      ),
      body: Column(
        children: [
          // 🔍 Search + Actions
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search inventory...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.swap_vert),
                  onPressed: () {
                    setState(() {
                      _sortBy = _sortBy == 'A-Z' ? 'Z-A' : 'A-Z';
                    });
                  },
                ),
                IconButton(
                  icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: () {
                    setState(() => _isGridView = !_isGridView);
                  },
                ),
              ],
            ),
          ),

          //  Items from Firebase
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: inventoryRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No items found'));
                }

                final items = _applyFilters(snapshot.data!.docs);

                if (items.isEmpty) {
                  return const Center(child: Text('No items found'));
                }

                return _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                        itemCount: items.length,
                        itemBuilder: (_, i) => _buildItemCard(items[i]),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (_, i) => _buildItemCard(items[i]),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(QueryDocumentSnapshot doc) {
    final item = doc.data() as Map<String, dynamic>;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemDetailScreen(
              itemId: doc.id,
              data: item,
              isGuest: true,
              itemIcons: itemIcons,
            ),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Icon(itemIcons[item['type']] ?? Icons.inventory_2, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item['location'] ?? '',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _statusOptions.map((status) {
            return RadioListTile(
              title: Text(status),
              value: status,
              groupValue: _selectedStatus,
              onChanged: (val) {
                setState(() {
                  _selectedStatus = val.toString();
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

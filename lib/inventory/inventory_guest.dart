import 'package:flutter/material.dart';
import 'item_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInventoryWidget extends StatefulWidget {
  @override
  State<UserInventoryWidget> createState() => _UserInventoryWidgetState();
}

class _UserInventoryWidgetState extends State<UserInventoryWidget> {
  late TextEditingController _searchController;

  String _selectedStatus = 'All';
  String _sortBy = 'A-Z';
  bool _isGridView = false;

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

  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'name': 'Wheelchair',
      'type': 'wheelchair',
      'category': 'Mobility Aid',
      'status': 'Available',
      'location': 'Ward A - Room 101',
      'quantity': '5',
      'price': '6.000',
      'description': 'Standard manual wheelchair.',
      'condition': 'New',
      'tags': ['Mobility'],
    },
    {
      'name': 'Walker',
      'type': 'walker',
      'category': 'Mobility Aid',
      'status': 'Rented',
      'location': 'Ward B - Room 205',
      'quantity': '3',
      'price': '4.500',
      'description': 'Lightweight aluminum walker.',
      'condition': 'Good',
      'tags': ['Portable'],
    },
    {
      'name': 'Hospital Bed',
      'type': 'hospital bed',
      'category': 'Furniture',
      'status': 'Maintenance',
      'location': 'Storage Room A',
      'quantity': '2',
      'price': '50.000',
      'description': 'Electric adjustable hospital bed.',
      'condition': 'Fair',
      'tags': ['Electric'],
    },
    {
      'name': 'Blood Pressure Monitor',
      'type': 'other',
      'category': 'Medical Device',
      'status': 'Donated',
      'location': 'Clinic Room 3',
      'quantity': '8',
      'price': '3.000',
      'description': 'Digital BP monitor.',
      'condition': 'Like new',
      'tags': ['Medical'],
    },
  ];

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_applyFilters);
    _filteredItems = List.from(_inventoryItems);
  }

  void _applyFilters() {
    setState(() {
      _filteredItems = _inventoryItems.where((item) {
        final searchMatch =
            item['name'].toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            item['category'].toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );

        final statusMatch =
            _selectedStatus == 'All' ||
            item['status'].toString().toLowerCase() ==
                _selectedStatus.toLowerCase();

        return searchMatch && statusMatch;
      }).toList();

      if (_sortBy == 'A-Z') {
        _filteredItems.sort((a, b) => a['name'].compareTo(b['name']));
      } else {
        _filteredItems.sort((a, b) => b['name'].compareTo(a['name']));
      }
    });
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
          // 🔍 Search + Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
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
                const SizedBox(width: 8),

                // Filter
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                ),

                // Sort
                IconButton(
                  icon: const Icon(Icons.swap_vert),
                  onPressed: () {
                    setState(() {
                      _sortBy = _sortBy == 'A-Z' ? 'Z-A' : 'A-Z';
                      _applyFilters();
                    });
                  },
                ),

                // View Toggle
                IconButton(
                  icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: () {
                    setState(() => _isGridView = !_isGridView);
                  },
                ),
              ],
            ),
          ),

          // 📦 Items
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(child: Text('No items found'))
                : _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: _filteredItems.length,
                    itemBuilder: (_, i) => _buildItemCard(_filteredItems[i]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (_, i) => _buildItemCard(_filteredItems[i]),
                  ),
          ),
        ],
      ),
    );
  }

  //  Card
  Widget _buildItemCard(Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItemDetailScreen(
              name: item['name'],
              category: item['category'],
              status: item['status'],
              location: item['location'],
              quantity: item['quantity'],
              description: item['description'],
              condition: item['condition'],
              tags: List<String>.from(item['tags']),
              rentalPrice: item['price'],
              isGuest: true,
              itemIcons: itemIcons,
              itemTypes: item['type'],
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
                    item['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(item['location'], style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🎛 Filter Dialog
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
                  _applyFilters();
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

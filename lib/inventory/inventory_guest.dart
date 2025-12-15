import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'item_detail.dart';

class UserInventoryWidget extends StatefulWidget {
  const UserInventoryWidget({super.key});

  @override
  State<UserInventoryWidget> createState() => _InventoryGuestState();
}

class _InventoryGuestState extends State<UserInventoryWidget> {
  final CollectionReference inventoryRef = FirebaseFirestore.instance
      .collection('inventory');

  final TextEditingController _searchController = TextEditingController();

  bool _isGridView = true;
  String sortBy = 'Default';

  List<QueryDocumentSnapshot> allItems = [];
  List<QueryDocumentSnapshot> filteredItems = [];

  List<String> selectedTypes = [];
  List<String> selectedCategories = [];
  List<String> selectedStatuses = [];
  List<String> selectedConditions = [];

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
    _loadItems();
    _searchController.addListener(_applyFilters);
  }

  Future<void> _loadItems() async {
    final snap = await inventoryRef.get();
    setState(() {
      allItems = snap.docs;
      filteredItems = snap.docs;
    });
  }

  void _applyFilters() {
    final search = _searchController.text.toLowerCase();

    filteredItems = allItems.where((doc) {
      final d = doc.data() as Map<String, dynamic>;

      final String name = d['name'] ?? '';
      final String category = d['category'] ?? 'Other';
      final String status = d['status'] ?? 'Available';
      final String type = d['type'] ?? 'other';
      final int quantity = d['quantity'] ?? 0;

      bool matchSearch =
          name.toLowerCase().contains(search) ||
          category.toLowerCase().contains(search);

      bool matchType = selectedTypes.isEmpty || selectedTypes.contains(type);

      bool matchCategory =
          selectedCategories.isEmpty ||
          selectedCategories.contains(d['category'] ?? 'Other');
      bool matchStatus =
          selectedStatuses.isEmpty ||
          selectedStatuses.contains(d['status'] ?? 'Available');

      bool matchCondition =
          selectedConditions.isEmpty ||
          selectedConditions.contains(d['condition'] ?? '');

      return matchSearch &&
          matchType &&
          matchCategory &&
          matchStatus &&
          matchCondition;
    }).toList();

    _applySort();
    setState(() {});
  }

  void _applySort() {
    switch (sortBy) {
      case 'NameAZ':
        filteredItems.sort(
          (a, b) => a['name'].toString().compareTo(b['name'].toString()),
        );
        break;
      case 'NameZA':
        filteredItems.sort(
          (a, b) => b['name'].toString().compareTo(a['name'].toString()),
        );
        break;
      case 'QtyLow':
        filteredItems.sort((a, b) => a['quantity'].compareTo(b['quantity']));
        break;
      case 'QtyHigh':
        filteredItems.sort((a, b) => b['quantity'].compareTo(a['quantity']));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF155DFC),
        title: const Text('Inventory', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterSheet,
                ),
                IconButton(
                  icon: const Icon(Icons.swap_vert),
                  onPressed: _showSortSheet,
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                  onPressed: () => setState(() => _isGridView = !_isGridView),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: filteredItems.length,
                    itemBuilder: (_, i) => _gridItem(filteredItems[i]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (_, i) => _listItem(filteredItems[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _gridItem(QueryDocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    final String name = d['name'] ?? '';
    final String status = d['status'] ?? 'Available';
    final String type = d['type'] ?? 'other';

    return InkWell(
      onTap: () => _openDetails(d, doc.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              itemIcons[type] ?? Icons.inventory_2,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),

            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            Text(
              status,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listItem(QueryDocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;

    final String name = d['name'] ?? '';
    final String category = d['category'] ?? 'Other';
    final String status = d['status'] ?? 'Available';
    final String type = d['type'] ?? 'other';
    final int quantity = d['quantity'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(itemIcons[type] ?? Icons.inventory_2, color: Colors.grey),
        title: Text(name),
        subtitle: Text(category),
        trailing: Text(
          status,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _openDetails(Map<String, dynamic> d, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemDetailScreen(
          itemId: id,
          data: d,
          isGuest: true,
          itemIcons: itemIcons,
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _filterTile('Available', selectedStatuses),
          _filterTile('Rented', selectedStatuses),
          _filterTile('Donated', selectedStatuses),
        ],
      ),
    );
  }

  Widget _filterTile(String v, List<String> list) {
    return CheckboxListTile(
      title: Text(v),
      value: list.contains(v),
      onChanged: (c) {
        setState(() {
          c! ? list.add(v) : list.remove(v);
          _applyFilters();
        });
      },
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _sortTile('Name A–Z', 'NameAZ'),
          _sortTile('Name Z–A', 'NameZA'),
          _sortTile('Qty Low–High', 'QtyLow'),
          _sortTile('Qty High–Low', 'QtyHigh'),
        ],
      ),
    );
  }

  Widget _sortTile(String t, String v) {
    return ListTile(
      title: Text(t),
      trailing: sortBy == v ? const Icon(Icons.check) : null,
      onTap: () {
        sortBy = v;
        _applyFilters();
        Navigator.pop(context);
      },
    );
  }
}

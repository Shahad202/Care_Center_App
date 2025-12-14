import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_item.dart';
import 'item_detail.dart';

class NewinventoryWidget extends StatefulWidget {
  @override
  State<NewinventoryWidget> createState() => _NewinventoryWidgetState();
}

class _NewinventoryWidgetState extends State<NewinventoryWidget> {
  final CollectionReference inventoryRef = FirebaseFirestore.instance
      .collection('inventory');

  final TextEditingController _searchController = TextEditingController();

  bool _isGridView = false;

  // 🔹 Filters
  List<String> selectedTypes = [];
  List<String> selectedCategories = [];
  List<String> selectedStatuses = [];
  List<String> selectedConditions = [];
  String selectedLocation = 'All Locations';

  // 🔹 Sort
  String sortBy = 'Default';

  List<QueryDocumentSnapshot> allItems = [];
  List<QueryDocumentSnapshot> filteredItems = [];

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
      bool matchSearch =
          d['name'].toString().toLowerCase().contains(search) ||
          d['category'].toString().toLowerCase().contains(search);

      bool matchType =
          selectedTypes.isEmpty ||
          selectedTypes.any(
            (t) => t.toLowerCase() == d['type'].toString().toLowerCase(),
          );

      bool matchCategory =
          selectedCategories.isEmpty ||
          selectedCategories.any(
            (c) => c.toLowerCase() == d['category'].toString().toLowerCase(),
          );

      bool matchStatus =
          selectedStatuses.isEmpty ||
          selectedStatuses.any(
            (s) => s.toLowerCase() == d['status'].toString().toLowerCase(),
          );

      bool matchCondition =
          selectedConditions.isEmpty ||
          selectedConditions.any(
            (c) => c.toLowerCase() == d['condition'].toString().toLowerCase(),
          );

      bool matchLocation =
          selectedLocation == 'All Locations' ||
          selectedLocation.toLowerCase() ==
              d['location'].toString().toLowerCase();

      return matchSearch &&
          matchType &&
          matchCategory &&
          matchStatus &&
          matchCondition &&
          matchLocation;
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
      case 'priceLow':
        filteredItems.sort((a, b) {
          final ap = double.tryParse(a['price'].toString()) ?? 0;
          final bp = double.tryParse(b['price'].toString()) ?? 0;
          return ap.compareTo(bp);
        });
        break;

      case 'priceHigh':
        filteredItems.sort((a, b) {
          final ap = double.tryParse(a['price'].toString()) ?? 0;
          final bp = double.tryParse(b['price'].toString()) ?? 0;
          return bp.compareTo(ap);
        });
        break;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Rented':
        return Colors.orange;
      case 'Maintenance':
        return Colors.grey;
      case 'Donated':
        return Colors.purple;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF155DFC),
        title: Text(
          'Inventory Management (${filteredItems.length})',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF155DFC),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
        onPressed: () async {
          final r = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddItemScreen()),
          );
          if (r == true) _loadItems();
        },
      ),
      body: Column(
        children: [
          // 🔍 Search
          Padding(
            padding: const EdgeInsets.all(16),
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

          //  Buttons Row
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

          //  Items
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text('No items found'))
                : _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                    itemCount: filteredItems.length,
                    itemBuilder: (_, i) => _buildCard(filteredItems[i]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (_, i) {
                      final doc = filteredItems[i];
                      final data = doc.data() as Map<String, dynamic>;
                      return _buildListTile(data, doc.id);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  //  Card
  Widget _buildCard(QueryDocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return InkWell(
      onTap: () => _openDetails(d, doc.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  itemIcons[d['type']] ?? Icons.inventory_2,
                  size: 60,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                d['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(Map<String, dynamic> d, String id) {
    final String name = d['name'] ?? '';
    final String category = d['category'] ?? '';
    final String status = d['status'] ?? '';
    final String type = d['type'] ?? 'other';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(itemIcons[type] ?? Icons.inventory_2),
        title: Text(name),
        subtitle: Text(category),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _statusColor(status),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
        onTap: () => _openDetails(d, id),
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
          isGuest: false,
          itemIcons: itemIcons,
        ),
      ),
    );
  }

  // 🔽 FILTER SHEET
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FilterSheet(
        onApply: (types, cats, stats, conds, loc) {
          selectedTypes = types;
          selectedCategories = cats;
          selectedStatuses = stats;
          selectedConditions = conds;
          selectedLocation = loc;
          _applyFilters();
        },
      ),
    );
  }

  // 🔽 SORT SHEET
  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _sortTile('Name (A – Z)', 'NameAZ'),
          _sortTile('Name (Z – A)', 'NameZA'),
          _sortTile('Quantity (Low – High)', 'QtyLow'),
          _sortTile('Quantity (High – Low)', 'QtyHigh'),
          _sortTile('Price (Low – High)', 'priceLow'),
          _sortTile('Price (High – Low)', 'priceHigh'),
        ],
      ),
    );
  }

  Widget _sortTile(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: sortBy == value ? const Icon(Icons.check) : null,
      onTap: () {
        sortBy = value;
        _applyFilters();
        Navigator.pop(context);
      },
    );
  }
}

class FilterSheet extends StatefulWidget {
  final Function(
    List<String> types,
    List<String> categories,
    List<String> statuses,
    List<String> conditions,
    String location,
  )
  onApply;

  const FilterSheet({super.key, required this.onApply});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final List<String> itemTypes = [
    'wheelchair',
    'walker',
    'crutches',
    'oxygen machine',
    'hospital bed',
    'other',
  ];

  final List<String> categories = [
    'Mobility Aid',
    'Medical Device',
    'Furniture',
    'Other',
  ];

  final List<String> statuses = [
    'Available',
    'Rented',
    'Donated',
    'Maintenance',
  ];

  final List<String> conditions = [
    'New',
    'Like new',
    'Good',
    'Fair',
    'Needs Repair',
  ];

  List<String> selectedTypes = [];
  List<String> selectedCategories = [];
  List<String> selectedStatuses = [];
  List<String> selectedConditions = [];
  String selectedLocation = 'All Locations';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _titleRow(context, 'Filters'),

              _section('Item Type', itemTypes, selectedTypes),
              _section('Category', categories, selectedCategories),
              _section('Availability Status', statuses, selectedStatuses),
              _section('Condition', conditions, selectedConditions),

              const SizedBox(height: 12),
              const Text('Location'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedLocation,
                items: ['All Locations']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedLocation = v!),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedTypes.clear();
                        selectedCategories.clear();
                        selectedStatuses.clear();
                        selectedConditions.clear();
                        selectedLocation = 'All Locations';
                      });
                    },
                    child: const Text('Reset'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      widget.onApply(
                        selectedTypes,
                        selectedCategories,
                        selectedStatuses,
                        selectedConditions,
                        selectedLocation,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleRow(BuildContext context, String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _section(String title, List<String> items, List<String> selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: items.map((e) {
            final isSelected = selected.contains(e);
            return ChoiceChip(
              label: Text(e),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  isSelected ? selected.remove(e) : selected.add(e);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

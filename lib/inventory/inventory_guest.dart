import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project444/login.dart';
import 'package:project444/profilePage.dart';
import 'item_detail.dart';

class UserInventoryWidget extends StatefulWidget {
  @override
  _UserInventoryWidgetState createState() => _UserInventoryWidgetState();
}

class _UserInventoryWidgetState extends State<UserInventoryWidget> {
  late TextEditingController _searchController;
  List<Map<String, dynamic>> _filteredItems = [];

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
      'description':
          'Standard manual wheelchair with adjustable footrests and armrests.',
      'condition': 'New',
      'tags': ['Mobility', 'Daily Use'],
    },
    {
      'name': 'Walker',
      'type': 'walker',
      'category': 'Mobility Aid',
      'status': 'Rented',
      'location': 'Ward B - Room 205',
      'quantity': '3',
      'price': '4.500',
      'description': 'Lightweight aluminum walker, easy to fold.',
      'condition': 'Good',
      'tags': ['Portable', 'Lightweight'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_filterItems);
    _filteredItems = _inventoryItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      _filteredItems = _inventoryItems.where((item) {
        return item['name'].toLowerCase().contains(
              _searchController.text.toLowerCase(),
            ) ||
            item['category'].toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 250, 251, 1),

      // ❌ No Drawer – Guest does not need menu
      appBar: AppBar(
        backgroundColor: const Color(0xFF155DFC),
        title: const Text(
          "Inventory",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // ❌ No Floating Button (no Add)
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF6B7280),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFD1D5DB),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),

            // Items List
            Padding(
              padding: const EdgeInsets.all(16),
              child: _filteredItems.isEmpty
                  ? const Text(
                      "No items found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return _buildItemCard(context, item);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Map<String, dynamic> item) {
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
              isGuest: true, // ⭐ VERY IMPORTANT
              itemIcons: itemIcons,
              type: item['type'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.05),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                itemIcons[item['type']] ?? Icons.inventory_2_outlined,
                size: 30,
                color: const Color(0xFF64748B),
              ),
            ),

            const SizedBox(width: 16),

            // Text info
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
                  Text(
                    item['category'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14),
                      Text(
                        item['location'],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

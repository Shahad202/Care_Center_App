import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_item.dart';

class ItemDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isGuest;
  final Map<String, IconData> itemIcons;
  final String itemId;

  const ItemDetailScreen({
    Key? key,
    required this.itemId,
    required this.data,
    required this.isGuest,
    required this.itemIcons,
  }) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  // 🔄 إعادة تحميل العنصر بعد التعديل
  Future<void> _reloadItem() async {
    final doc = await FirebaseFirestore.instance
        .collection('inventory')
        .doc(widget.itemId)
        .get();

    if (doc.exists) {
      setState(() {
        widget.data.clear();
        widget.data.addAll(doc.data()!);
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color.fromRGBO(0, 201, 80, 1);
      case 'Rented':
        return const Color.fromRGBO(255, 105, 0, 1);
      case 'Maintenance':
        return const Color.fromRGBO(106, 114, 130, 1);
      case 'Donated':
        return const Color.fromRGBO(173, 59, 183, 1);
      default:
        return const Color.fromRGBO(170, 192, 235, 1);
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'New':
        return const Color.fromRGBO(220, 252, 231, 1);
      case 'Like new':
        return const Color.fromARGB(255, 244, 220, 252);
      case 'Good':
        return const Color.fromRGBO(219, 234, 254, 1);
      case 'Fair':
        return const Color.fromRGBO(254, 243, 199, 1);
      case 'Needs Repair':
        return const Color.fromRGBO(254, 226, 226, 1);
      default:
        return const Color.fromRGBO(242, 244, 246, 1);
    }
  }

  Color _getConditionTextColor(String condition) {
    switch (condition) {
      case 'New':
        return const Color.fromRGBO(34, 197, 94, 1);
      case 'Like new':
        return const Color.fromARGB(255, 177, 127, 193);
      case 'Good':
        return const Color.fromRGBO(59, 130, 246, 1);
      case 'Fair':
        return const Color.fromRGBO(202, 138, 4, 1);
      case 'Needs Repair':
        return const Color.fromRGBO(239, 68, 68, 1);
      default:
        return const Color.fromRGBO(107, 114, 128, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.data['name'] ?? '';
    final String type = widget.data['type'] ?? 'other';
    final String category = widget.data['category'] ?? '';
    final String status = widget.data['status'] ?? '';
    final String location = widget.data['location'] ?? '';
    final String quantity = widget.data['quantity']?.toString() ?? '0';
    final String description = widget.data['description'] ?? '';
    final String condition = widget.data['condition'] ?? '';
    final String rentalPrice = widget.data['price']?.toString() ?? '0.000';
    final List<String> tags = List<String>.from(widget.data['tags'] ?? []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(21, 93, 252, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Item Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 ICON + STATUS
            Container(
              width: double.infinity,
              height: 250,
              color: const Color.fromRGBO(243, 244, 246, 1),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      widget.itemIcons[type.toLowerCase()] ??
                          Icons.inventory_2_outlined,
                      size: 120,
                      color: const Color.fromRGBO(100, 116, 139, 1),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 DETAILS
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _detail(Icons.type_specimen, 'Item Type', type),
                  _detail(Icons.category, 'Category', category),
                  _detail(
                    Icons.description,
                    'Description',
                    description,
                    large: true,
                  ),
                  _conditionDetail(condition),
                  _detail(Icons.inventory_2, 'Quantity', '$quantity units'),
                  _detail(Icons.location_on, 'Location', location),
                  _tags(tags),
                  _detail(
                    Icons.attach_money,
                    'Rental Price',
                    'BD $rentalPrice per day',
                  ),

                  const SizedBox(height: 32),

                  // ✏️ EDIT BUTTON
                  if (!widget.isGuest)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final r = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditItemScreen(
                                itemId: widget.itemId,
                                data: widget.data,
                              ),
                            ),
                          );

                          if (r == true) {
                            await _reloadItem(); // ✅ تحديث التفاصيل
                          }
                        },
                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Edit Item',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(21, 93, 252, 1),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detail(
    IconData icon,
    String label,
    String value, {
    bool large = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(249, 250, 251, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(229, 231, 235, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color.fromRGBO(21, 93, 252, 1)),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: large ? 14 : 16)),
        ],
      ),
    );
  }

  Widget _conditionDetail(String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getConditionColor(value),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: _getConditionTextColor(value),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _tags(List<String> tags) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(249, 250, 251, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(229, 231, 235, 1)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags
            .map(
              (t) => Chip(
                label: Text(t),
                backgroundColor: const Color.fromRGBO(219, 234, 254, 1),
              ),
            )
            .toList(),
      ),
    );
  }
}

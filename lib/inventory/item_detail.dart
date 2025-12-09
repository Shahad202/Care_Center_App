import 'package:flutter/material.dart';
import 'package:project444/inventory/edit_item.dart';

class ItemDetailScreen extends StatefulWidget {
  final String name;
  final String category;
  final String status;
  final String location;
  final String quantity;
  final String description;
  final String condition;
  final List<String> tags;
  final String rentalPrice;

  const ItemDetailScreen({
    Key? key,
    required this.name,
    required this.category,
    required this.status,
    required this.location,
    required this.quantity,
    required this.description,
    required this.condition,
    required this.tags,
    required this.rentalPrice,
  }) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Available':
        return const Color.fromRGBO(0, 201, 80, 1);
      case 'Rented':
        return const Color.fromRGBO(255, 105, 0, 1);
      case 'Maintenance':
        return const Color.fromRGBO(106, 114, 130, 1);
      default:
        return const Color.fromRGBO(106, 114, 130, 1);
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'Excellent':
        return const Color.fromRGBO(220, 252, 231, 1);
      case 'Good':
        return const Color.fromRGBO(219, 234, 254, 1);
      case 'Fair':
        return const Color.fromRGBO(254, 243, 199, 1);
      case 'Poor':
        return const Color.fromRGBO(254, 226, 226, 1);
      default:
        return const Color.fromRGBO(242, 244, 246, 1);
    }
  }

  Color _getConditionTextColor(String condition) {
    switch (condition) {
      case 'Excellent':
        return const Color.fromRGBO(34, 197, 94, 1);
      case 'Good':
        return const Color.fromRGBO(59, 130, 246, 1);
      case 'Fair':
        return const Color.fromRGBO(202, 138, 4, 1);
      case 'Poor':
        return const Color.fromRGBO(239, 68, 68, 1);
      default:
        return const Color.fromRGBO(107, 114, 128, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(21, 93, 252, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Item Details',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Arimo',
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Image with Status Badge
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(243, 244, 246, 1),
                image: DecorationImage(
                  image: AssetImage('assets/images/Imagewithfallback.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Arimo',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Name
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Color.fromRGBO(31, 41, 55, 1),
                      fontFamily: 'Arimo',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Type Section
                  _buildDetailSection(
                    icon: Icons.category,
                    label: 'Type',
                    value: widget.category,
                  ),
                  const SizedBox(height: 16),

                  // Description Section
                  _buildDetailSection(
                    icon: Icons.description,
                    label: 'Description',
                    value: widget.description,
                    isLargeText: true,
                  ),
                  const SizedBox(height: 16),

                  // Condition Section
                  _buildDetailSection(
                    icon: Icons.check_circle,
                    label: 'Condition',
                    value: widget.condition,
                    isCondition: true,
                    conditionColor: _getConditionColor(widget.condition),
                    conditionTextColor: _getConditionTextColor(
                      widget.condition,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Section
                  _buildDetailSection(
                    icon: Icons.inventory_2,
                    label: 'Quantity',
                    value: '${widget.quantity} units',
                  ),
                  const SizedBox(height: 16),

                  // Location Section
                  _buildDetailSection(
                    icon: Icons.location_on,
                    label: 'Location',
                    value: widget.location,
                  ),
                  const SizedBox(height: 16),

                  // Tags Section
                  _buildTagsSection(),
                  const SizedBox(height: 16),

                  // Rental Price Section
                  _buildDetailSection(
                    icon: Icons.attach_money,
                    label: 'Rental Price',
                    value: 'BD ${widget.rentalPrice} per day',
                  ),
                  const SizedBox(height: 32),

                  // Edit Item Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditItemScreen(
                              name: widget.name,
                              category: widget.category,
                              status: widget.status,
                              location: widget.location,
                              quantity: widget.quantity,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(21, 93, 252, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        'Edit Item',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Arimo',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String label,
    required String value,
    bool isLargeText = false,
    bool isCondition = false,
    Color? conditionColor,
    Color? conditionTextColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(249, 250, 251, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(229, 231, 235, 1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color.fromRGBO(21, 93, 252, 1), size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color.fromRGBO(107, 114, 128, 1),
                  fontFamily: 'Arimo',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isCondition)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: conditionColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: conditionTextColor,
                  fontFamily: 'Arimo',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Text(
              value,
              style: TextStyle(
                color: const Color.fromRGBO(31, 41, 55, 1),
                fontFamily: 'Arimo',
                fontSize: isLargeText ? 14 : 16,
                fontWeight: FontWeight.w600,
                height: isLargeText ? 1.5 : 1.0,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(249, 250, 251, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(229, 231, 235, 1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_offer,
                color: Color.fromRGBO(21, 93, 252, 1),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Tags',
                style: TextStyle(
                  color: Color.fromRGBO(107, 114, 128, 1),
                  fontFamily: 'Arimo',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(219, 234, 254, 1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Color.fromRGBO(21, 93, 252, 1),
                    fontFamily: 'Arimo',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

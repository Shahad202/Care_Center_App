import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditItemScreen extends StatefulWidget {
  final String name;
  final String itemTypes;
  final String category;
  final String status;
  final String location;
  final String description;
  final String condition;
  final String quantity;
  final String rentalPrice;

  const EditItemScreen({
    Key? key,
    required this.name,
    required this.itemTypes,
    required this.category,
    required this.status,
    required this.location,
    required this.description,
    required this.condition,
    required this.quantity,
    required this.rentalPrice,
  }) : super(key: key);

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _itemTypesController;
  late TextEditingController _categoryController;
  late TextEditingController _locationController;
  late TextEditingController _statusController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  late TextEditingController _conditionController;
  late TextEditingController _tagController;
  late TextEditingController _rentalPriceController;

  List<String> _tags = ['Mobility', 'Medical Equipment', 'Daily Use'];

  IconData? _selectedIcon;
  void _showIconSelectionDialog() {
    final icons = {
      'wheelchair': Icons.wheelchair_pickup,
      'walker': Icons.accessibility_new,
      'crutches': Icons.elderly,
      'oxygen machine': Icons.medical_services,
      'hospital bed': Icons.bed,
      'other': Icons.inventory_2,
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Select Icon"),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: GridView.count(
              crossAxisCount: 6,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: icons.values.map((icon) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIcon = icon);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(icon, size: 32, color: Colors.black87),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  final List<String> _itemTypes = [
    'wheelchair',
    'walker',
    'crutches',
    'oxygen machine',
    'hospital bed',
    'other',
  ];
  final List<String> _categoryOptions = [
    'Mobility Aid',
    'Medical Device',
    'Furniture',
    'Other',
  ];

  final List<String> _conditionOptions = [
    'New',
    'Like new',
    'Good',
    'Fair',
    'Needs Repair',
  ];

  final List<String> _statusOptions = [
    'Available',
    'Rented',
    'Donated',
    'Maintenance',
  ];

  final List<String> _locationOptions = [
    'Ward A - Room 101',
    'Ward B - Room 205',
    'Clinic Room 3',
    'Storage Room A',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _itemTypesController = TextEditingController(text: widget.itemTypes);
    _categoryController = TextEditingController(text: widget.category);
    _locationController = TextEditingController(text: widget.location);
    _statusController = TextEditingController(text: widget.status);
    _quantityController = TextEditingController(text: widget.quantity);
    _conditionController = TextEditingController(text: widget.condition);
    _descriptionController = TextEditingController(text: widget.description);
    _tagController = TextEditingController();
    _rentalPriceController = TextEditingController(text: widget.rentalPrice);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _itemTypesController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _statusController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _conditionController.dispose();
    _tagController.dispose();
    _rentalPriceController.dispose();
    super.dispose();
  }

  void _addTag() {
    if (_tagController.text.trim().isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text.trim());
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item updated successfully!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color.fromRGBO(0, 201, 80, 1),
      ),
    );
    Navigator.pop(context);
  }

  void _deleteItem() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Item',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(31, 41, 55, 1),
            ),
          ),
          content: const Text(
            'Are you sure you want to delete this item? This action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(107, 114, 128, 1),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color.fromRGBO(107, 114, 128, 1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item deleted successfully!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Color.fromRGBO(239, 68, 68, 1),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(239, 68, 68, 1),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
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
          'Edit Item',
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Name Field
              _buildFieldLabel('Item Name *'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _nameController,
                hintText: 'Enter item name',
              ),
              const SizedBox(height: 20),

              // Item Type Field
              _buildFieldLabel('Item Type *'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: _itemTypesController.text,
                items: _itemTypes,
                onChanged: (value) {
                  setState(() {
                    _itemTypesController.text = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),

              // Item Type Field
              _buildFieldLabel('Category *'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: _categoryController.text,
                items: _categoryOptions,
                onChanged: (value) {
                  setState(() {
                    _categoryController.text = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),

              // Description Field
              _buildFieldLabel('Description *'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _descriptionController,
                hintText: 'Enter item description',
                maxLines: 4,
              ),
              const SizedBox(height: 20),

              // Condition Field
              _buildFieldLabel('Condition *'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: _conditionController.text,
                items: _conditionOptions,
                onChanged: (value) {
                  setState(() {
                    _conditionController.text = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),

              // Location Field
              _buildFieldLabel('Location *'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _locationController,
                hintText: 'Enter location',
              ),
              const SizedBox(height: 20),

              // Availability Status Field
              _buildFieldLabel('Availability Status *'),
              const SizedBox(height: 8),
              _buildDropdownField(
                value: _statusController.text,
                items: _statusOptions,
                onChanged: (value) {
                  setState(() {
                    _statusController.text = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),

              // Quantity Field
              _buildFieldLabel('Quantity *'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _quantityController,
                hintText: 'Enter quantity',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Tags Section
              _buildFieldLabel('Tags'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        hintText: 'Add a tag',
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(156, 163, 175, 1),
                          fontFamily: 'Arimo',
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: const Color.fromRGBO(249, 250, 251, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(208, 213, 219, 1),
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(208, 213, 219, 1),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(21, 93, 252, 1),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addTag,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(21, 93, 252, 1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Tags Display
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(219, 234, 254, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tag,
                          style: const TextStyle(
                            color: Color.fromRGBO(21, 93, 252, 1),
                            fontFamily: 'Arimo',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => _removeTag(tag),
                          child: const Icon(
                            Icons.close,
                            color: Color.fromRGBO(21, 93, 252, 1),
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Select Icon'),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _showIconSelectionDialog,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF9FAFB),
                    border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedIcon ??
                            Icons.upload, // الأيقونة الحالية أو افتراضية
                        size: 40,
                        color: const Color(0xFF94A3B8),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Tap to choose an icon",
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Rental Price Field
              _buildFieldLabel('Rental Price Per Day (Optional)'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(
                    width: 50,
                    child: Text(
                      'BHD',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(31, 41, 55, 1),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildTextField(
                      controller: _rentalPriceController,
                      hintText: 'Enter price',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(21, 93, 252, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Arimo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Delete Item Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _deleteItem,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color.fromRGBO(239, 68, 68, 1),
                      width: 1.5,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Color.fromRGBO(239, 68, 68, 1),
                    size: 20,
                  ),
                  label: const Text(
                    'Delete Item',
                    style: TextStyle(
                      color: Color.fromRGBO(239, 68, 68, 1),
                      fontFamily: 'Arimo',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(21, 93, 252, 1),
        fontFamily: 'Arimo',
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color.fromRGBO(156, 163, 175, 1),
          fontFamily: 'Arimo',
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color.fromRGBO(249, 250, 251, 1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color.fromRGBO(208, 213, 219, 1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color.fromRGBO(208, 213, 219, 1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color.fromRGBO(21, 93, 252, 1),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(208, 213, 219, 1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromRGBO(249, 250, 251, 1),
      ),
      child: DropdownButton<String>(
        value: value.isNotEmpty ? value : items.first,
        isExpanded: true,
        underline: const SizedBox(),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                item,
                style: const TextStyle(
                  color: Color.fromRGBO(31, 41, 55, 1),
                  fontFamily: 'Arimo',
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

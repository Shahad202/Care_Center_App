import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  late TextEditingController _itemNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _rentalPriceController;

  // Form State Variables
  String? _selectedItemType;
  String? _selectedCondition;
  int _quantity = 1;
  List<String> _tags = [];
  String _newTag = '';

  final List<String> _itemTypes = [
    'wheelchair',
    'walker',
    'crutches',
    'oxygen machine',
    'hospital bed',
    'other',
  ];
  final List<String> _categories = [
    'Mobility Aid',
    'Medical Device',
    'Furniture',
    'Other',
  ];

  String? _selectedCategory;

  final Map<String, IconData> itemIcons = {
    'wheelchair': Icons.wheelchair_pickup,
    'walker': Icons.accessibility_new,
    'crutches': Icons.elderly,
    'oxygen machine': Icons.medical_services,
    'hospital bed': Icons.bed,
    'other': Icons.inventory_2,
  };

  String? _selectedIconKey; // icon selected by user

  final List<String> _conditions = [
    'New',
    'Like new',
    'Good',
    'Fair',
    'Needs Repair',
  ];

  // Location list
  final List<String> locationOptions = [
    'Ward A - Room 101',
    'Ward B - Room 205',
    'Clinic Room 3',
    'Storage Room A',
  ];

  // Availability Status list
  final List<String> availabilityOptions = [
    'Available',
    'Rented',
    'Donated',
    'Maintenance',
  ];

  // Selected values
  String? _selectedLocation;
  String? _selectedAvailability;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _rentalPriceController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _rentalPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF155DFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Item',
          style: TextStyle(
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Name Field
              _buildFormField(
                label: 'Item Name *',
                hintText: 'Enter item name',
                controller: _itemNameController,
              ),
              const SizedBox(height: 20),

              _buildDropdownField(
                label: 'Category *',
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
              ),

              const SizedBox(height: 20),

              // Item Type Dropdown
              _buildDropdownField(
                label: 'Item Type *',
                value: _selectedItemType,
                items: _itemTypes,
                onChanged: (value) {
                  setState(() => _selectedItemType = value);
                },
              ),
              const SizedBox(height: 20),

              // Description Field
              _buildFormField(
                label: 'Description *',
                hintText: 'Enter item description',
                controller: _descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 20),

              // Condition Dropdown
              _buildDropdownField(
                label: 'Condition *',
                value: _selectedCondition,
                items: _conditions,
                onChanged: (value) {
                  setState(() => _selectedCondition = value);
                },
              ),
              const SizedBox(height: 20),

              // Quantity Field
              _buildQuantityField(),
              const SizedBox(height: 20),

              // Location Field
              _buildDropdownField(
                label: 'Location *',
                value: _selectedLocation,
                items: locationOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Availability Status Field
              _buildDropdownField(
                label: 'Availability Status *',
                value: _selectedAvailability,
                items: availabilityOptions,
                onChanged: (value) {
                  setState(() {
                    _selectedAvailability = value!;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Tags Field
              _buildTagsField(),
              const SizedBox(height: 20),

              // Upload Images
              _buildIconPickerSection(),
              const SizedBox(height: 20),

              // Rental Price Field
              _buildFormField(
                label: 'Rental Price Per Day (Optional)',
                hintText: 'BD 0.000',
                controller: _rentalPriceController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF155DFC),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Item',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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

  Widget _buildFormField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(31, 41, 55, 1),
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color.fromRGBO(156, 163, 175, 1),
              fontFamily: 'Arimo',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color.fromRGBO(209, 213, 219, 1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color.fromRGBO(209, 213, 219, 1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF155DFC), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color.fromRGBO(31, 41, 55, 1),
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color.fromRGBO(209, 213, 219, 1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color.fromRGBO(209, 213, 219, 1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF155DFC), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          validator: (value) {
            if (value == null) {
              return 'Please select an option';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity *',
          style: TextStyle(
            color: Color.fromRGBO(31, 41, 55, 1),
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromRGBO(209, 213, 219, 1)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _quantity > 1
                    ? () {
                        setState(() => _quantity--);
                      }
                    : null,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                color: const Color(0xFF155DFC),
                onPressed: () {
                  setState(() => _quantity++);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            color: Color.fromRGBO(31, 41, 55, 1),
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) => _newTag = value,
                decoration: InputDecoration(
                  hintText: 'Add a tag',
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(156, 163, 175, 1),
                    fontFamily: 'Arimo',
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(209, 213, 219, 1),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(209, 213, 219, 1),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addTag,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF155DFC),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arimo',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: _tags.map((tag) {
            return Chip(
              label: Text(tag),
              onDeleted: () {
                setState(() => _tags.remove(tag));
              },
              backgroundColor: const Color.fromRGBO(242, 244, 246, 1),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIconPickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Icon',
          style: TextStyle(
            color: Color.fromRGBO(31, 41, 55, 1),
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),

        // Display selected icon
        GestureDetector(
          onTap: () => _showIconSelectionDialog(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromRGBO(209, 213, 219, 1)),
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromRGBO(249, 250, 251, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedIconKey != null
                      ? itemIcons[_selectedIconKey]
                      : Icons.cloud_upload_outlined,
                  size: 40,
                  color: const Color.fromRGBO(156, 163, 175, 1),
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedIconKey != null
                      ? "Selected: $_selectedIconKey"
                      : 'Tap to choose an icon',
                  style: const TextStyle(
                    color: Color.fromRGBO(107, 114, 128, 1),
                    fontFamily: 'Arimo',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _addTag() {
    if (_newTag.isNotEmpty) {
      setState(() {
        _tags.add(_newTag);
        _newTag = '';
      });
    }
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = {
        'name': _itemNameController.text.trim(),
        'category': _selectedCategory,
        'type': _selectedItemType,
        'description': _descriptionController.text.trim(),
        'condition': _selectedCondition,
        'quantity': _quantity.toString(),
        'location': _selectedLocation,
        'status': _selectedAvailability,
        'tags': _tags,
        'price': _rentalPriceController.text.trim(),
      };

      print("NEW ITEM ADDED: $newItem");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item saved successfully!')));

      Navigator.pop(context);
    }
  }

  void _showIconSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Choose Icon",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 6,
              shrinkWrap: true,
              children: itemIcons.entries.map((entry) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIconKey = entry.key;
                    });
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(entry.value, size: 40, color: Colors.blueGrey),
                      const SizedBox(height: 6),
                      Text(
                        entry.key,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

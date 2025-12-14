import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference inventoryRef = FirebaseFirestore.instance
      .collection('inventory');

  late TextEditingController _itemNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _rentalPriceController;
  late TextEditingController _locationController;
  String? _selectedItemType;
  String? _selectedCategory;
  String? _selectedCondition;
  String? _selectedLocation;
  String? _selectedAvailability;

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

  final List<String> _conditions = [
    'New',
    'Like new',
    'Good',
    'Fair',
    'Needs Repair',
  ];

  final List<String> _statuses = [
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

  String? _selectedIconKey;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _rentalPriceController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _rentalPriceController.dispose();
    super.dispose();
    _locationController.dispose();
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    await inventoryRef.add({
      'name': _itemNameController.text.trim(),
      'category': _selectedCategory,
      'type': _selectedItemType ?? 'other',
      'description': _descriptionController.text.trim(),
      'condition': _selectedCondition,
      'quantity': _quantity,
      'location': _locationController.text.trim(),
      'status': _selectedAvailability,
      'tags': _tags,
      'price': _rentalPriceController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item saved successfully!'),
        backgroundColor: Color.fromRGBO(0, 201, 80, 1),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF155DFC),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add New Item',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textField('Item Name *', _itemNameController),
              _dropdown(
                'Category *',
                _selectedCategory,
                _categories,
                (v) => setState(() => _selectedCategory = v),
              ),
              _dropdown(
                'Item Type *',
                _selectedItemType,
                _itemTypes,
                (v) => setState(() => _selectedItemType = v),
              ),
              _textField('Description *', _descriptionController, lines: 4),
              _dropdown(
                'Condition *',
                _selectedCondition,
                _conditions,
                (v) => setState(() => _selectedCondition = v),
              ),
              _quantityField(),
              _textField('Location *', _locationController),

              _dropdown(
                'Availability Status *',
                _selectedAvailability,
                _statuses,
                (v) => setState(() => _selectedAvailability = v),
              ),
              _tagsField(),
              _iconPicker(),
              _textField(
                'Rental Price (Optional)',
                _rentalPriceController,
                number: true,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveItem,
                  child: const Text('Save Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
    String label,
    TextEditingController c, {
    int lines = 1,
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: c,
        maxLines: lines,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
        validator: (v) => (v == null || v.isEmpty) ? 'Required field' : null,
      ),
    );
  }

  Widget _dropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (v) => v == null ? 'Required field' : null,
      ),
    );
  }

  Widget _quantityField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          const Text('Quantity'),
          const Spacer(),
          IconButton(
            onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
            icon: const Icon(Icons.remove),
          ),
          Text('$_quantity'),
          IconButton(
            onPressed: () => setState(() => _quantity++),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _tagsField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tags'),
          Row(
            children: [
              Expanded(child: TextField(onChanged: (v) => _newTag = v)),
              ElevatedButton(
                onPressed: () {
                  if (_newTag.isNotEmpty) {
                    setState(() {
                      _tags.add(_newTag);
                      _newTag = '';
                    });
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: _tags
                .map(
                  (t) => Chip(
                    label: Text(t),
                    onDeleted: () => setState(() => _tags.remove(t)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _iconPicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => _showIconDialog(),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Center(
            child: Icon(
              _selectedIconKey != null
                  ? itemIcons[_selectedIconKey]
                  : Icons.cloud_upload_outlined,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  void _showIconDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Choose Icon'),
        content: Wrap(
          spacing: 12,
          children: itemIcons.entries
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    setState(() => _selectedIconKey = e.key);
                    Navigator.pop(context);
                  },
                  child: Icon(e.value, size: 36),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

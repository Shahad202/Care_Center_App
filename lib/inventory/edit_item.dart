import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditItemScreen extends StatefulWidget {
  final String itemId;
  final Map<String, dynamic> data;

  const EditItemScreen({super.key, required this.itemId, required this.data});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final CollectionReference inventoryRef = FirebaseFirestore.instance
      .collection('inventory');

  String? _selectedType;
  String? _selectedCategory;
  String? _selectedCondition;
  String? _selectedStatus;

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _tagController;

  List<String> _tags = [];

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

  @override
  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.data['name']);
    _descriptionController = TextEditingController(
      text: widget.data['description'],
    );
    _locationController = TextEditingController(text: widget.data['location']);
    _quantityController = TextEditingController(
      text: widget.data['quantity'].toString(),
    );
    _priceController = TextEditingController(
      text: widget.data['price']?.toString() ?? '0',
    );

    _tagController = TextEditingController();
    _tags = List<String>.from(widget.data['tags'] ?? []);

    // ✅ ربط القيم مع الدروب داون
    _selectedType = _itemTypes.contains(widget.data['type'])
        ? widget.data['type']
        : _itemTypes.first;

    _selectedCategory = _categories.contains(widget.data['category'])
        ? widget.data['category']
        : _categories.first;

    _selectedCondition = _conditions.contains(widget.data['condition'])
        ? widget.data['condition']
        : _conditions.first;

    _selectedStatus = _statuses.contains(widget.data['status'])
        ? widget.data['status']
        : _statuses.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  // ✅ SAVE
  Future<void> _saveChanges() async {
    await inventoryRef.doc(widget.itemId).update({
      'name': _nameController.text.trim(),
      'type': _selectedType,
      'category': _selectedCategory,
      'condition': _selectedCondition,
      'status': _selectedStatus,
      'location': _locationController.text.trim(),
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'price': double.tryParse(_priceController.text) ?? 0,
      'tags': _tags,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    Navigator.pop(context, true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // 🗑 DELETE
  Future<void> _deleteItem() async {
    await inventoryRef.doc(widget.itemId).delete();
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item deleted successfully!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteItem();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
    setState(() => _tags.remove(tag));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF155DFC),
        title: const Text('Edit Item', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Item Name'),
            _text(_nameController),

            _dropdownField(
              'Item Type',
              _selectedType,
              _itemTypes,
              (v) => setState(() => _selectedType = v),
            ),

            _dropdownField(
              'Category',
              _selectedCategory,
              _categories,
              (v) => setState(() => _selectedCategory = v),
            ),

            _label('Description'),
            _text(_descriptionController, lines: 4),

            _dropdownField(
              'Condition',
              _selectedCondition,
              _conditions,
              (v) => setState(() => _selectedCondition = v),
            ),

            _label('Location'),
            _text(_locationController),

            _dropdownField(
              'Status',
              _selectedStatus,
              _statuses,
              (v) => setState(() => _selectedStatus = v),
            ),
            _label('Quantity'),
            _text(_quantityController, number: true),

            _label('Rental Price'),
            _text(_priceController, number: true),

            _label('Tags'),
            Row(
              children: [
                Expanded(child: _text(_tagController)),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addTag, child: const Text('Add')),
              ],
            ),
            Wrap(
              spacing: 8,
              children: _tags
                  .map(
                    (t) => Chip(label: Text(t), onDeleted: () => _removeTag(t)),
                  )
                  .toList(),
            ),

            const SizedBox(height: 30),

            // ✅ SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ),

            const SizedBox(height: 12),

            // 🗑 DELETE BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _confirmDelete,
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Text(
      t,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    ),
  );

  Widget _text(TextEditingController c, {int lines = 1, bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        maxLines: lines,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: const InputDecoration(
          filled: true,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown(TextEditingController c, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: c.text.isNotEmpty ? c.text : items.first,
        decoration: const InputDecoration(
          filled: true,
          border: OutlineInputBorder(),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => c.text = v!),
      ),
    );
  }
}

Widget _dropdownField(
  String label,
  String? value,
  List<String> items,
  Function(String?) onChanged,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, filled: true),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    ),
  );
}

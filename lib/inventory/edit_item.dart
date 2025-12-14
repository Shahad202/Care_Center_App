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

  late TextEditingController _nameController;
  late TextEditingController _typeController;
  late TextEditingController _categoryController;
  late TextEditingController _locationController;
  late TextEditingController _statusController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  late TextEditingController _conditionController;
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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data['name'] ?? '');
    _typeController = TextEditingController(text: widget.data['type'] ?? '');
    _categoryController = TextEditingController(
      text: widget.data['category'] ?? '',
    );
    _locationController = TextEditingController(
      text: widget.data['location'] ?? '',
    );
    _statusController = TextEditingController(
      text: widget.data['status'] ?? '',
    );
    _quantityController = TextEditingController(
      text: widget.data['quantity'].toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.data['description'] ?? '',
    );
    _conditionController = TextEditingController(
      text: widget.data['condition'] ?? '',
    );
    _priceController = TextEditingController(
      text: widget.data['price'] ?? '0.000',
    );
    _tagController = TextEditingController();
    _tags = List<String>.from(widget.data['tags'] ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _categoryController.dispose();
    _locationController.dispose();
    _statusController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    _conditionController.dispose();
    _priceController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  // ✅ SAVE
  Future<void> _saveChanges() async {
    await inventoryRef.doc(widget.itemId).update({
      'name': _nameController.text.trim(),
      'type': _typeController.text,
      'category': _categoryController.text,
      'location': _locationController.text.trim(),
      'status': _statusController.text,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'description': _descriptionController.text.trim(),
      'condition': _conditionController.text,
      'price': _priceController.text.trim(),
      'tags': _tags,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  }

  // 🗑 DELETE
  Future<void> _deleteItem() async {
    await inventoryRef.doc(widget.itemId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item deleted successfully!'),
        backgroundColor: Colors.red,
      ),
    );

    Navigator.pop(context, true);
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

            _label('Item Type'),
            _dropdown(_typeController, _itemTypes),

            _label('Category'),
            _dropdown(_categoryController, _categories),

            _label('Description'),
            _text(_descriptionController, lines: 4),

            _label('Condition'),
            _dropdown(_conditionController, _conditions),

            _label('Location'),
            _text(_locationController),

            _label('Status'),
            _dropdown(_statusController, _statuses),

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
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  Widget _text(TextEditingController c, {int lines = 1, bool number = false}) {
    return TextField(
      controller: c,
      maxLines: lines,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      decoration: const InputDecoration(filled: true),
    );
  }

  Widget _dropdown(TextEditingController c, List<String> items) {
    return DropdownButtonFormField<String>(
      value: c.text.isNotEmpty ? c.text : items.first,
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (v) => setState(() => c.text = v!),
    );
  }
}

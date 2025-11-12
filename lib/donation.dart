import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  // Form fields
  String? selectedEquipmentType;
  String? selectedCondition;
  List<File> selectedImages = [];

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final List<String> equipmentTypes = [
    'Wheelchair', 
    'Walker', 
    'Crutches', 
    'Hospital Bed',
    'Oxygen Machine', 
    'Cane', 
    'Mobility Scooter', 
    'Other',
  ];

  final List<String> conditionStatus = [
    'Excellent', 
    'Good', 
    'Fair', 
    'Needs Repair',
  ];

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Donate Equipment', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Share Your Equipment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Help those in need by donating assistive equipment.'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Item Name
                TextFormField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name *',
                    prefixIcon: Icon(Icons.medical_services),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter item name' : null,
                ),
                const SizedBox(height: 20),

                // Equipment Type
                DropdownButtonFormField<String>(
                  value: selectedEquipmentType,
                  hint: const Text('Select equipment type'),
                  items: equipmentTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                  onChanged: (value) => setState(() => selectedEquipmentType = value),
                  decoration: const InputDecoration(
                    labelText: 'Equipment Type *',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null ? 'Please select equipment type' : null,
                ),
                const SizedBox(height: 20),

                // Condition
                DropdownButtonFormField<String>(
                  value: selectedCondition,
                  hint: const Text('Select condition'),
                  items: conditionStatus.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (value) => setState(() => selectedCondition = value),
                  decoration: const InputDecoration(
                    labelText: 'Condition *',
                    prefixIcon: Icon(Icons.info),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null ? 'Please select condition' : null,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
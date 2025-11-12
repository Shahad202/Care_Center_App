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
    'Wheelchair', 'Walker', 'Crutches', 'Hospital Bed',
    'Oxygen Machine', 'Cane', 'Mobility Scooter', 'Other',
  ];

  final List<String> conditionStatus = [
    'Excellent', 'Good', 'Fair', 'Needs Repair',
  ];

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _quantityController.dispose();
    super.dispose();
  }
}
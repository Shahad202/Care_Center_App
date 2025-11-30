import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';

import 'donation_service.dart';
import 'donation_item.dart';

class DonationFormPage extends StatefulWidget {
  const DonationFormPage({super.key});

  @override
  State<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _selectedCondition;
  final List<String> _conditions = ['New', 'Like New', 'Good', 'Fair', 'Needs Repair'];

  final List<XFile> _uploadedImages = [];
  final ImagePicker _picker = ImagePicker();

  // RegEx to detect invalid characters (@ and < >)
  final RegExp _invalidCharsRegex = RegExp(r'[@<>]');

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    if (_uploadedImages.length >= 6) {
      _showMessage('Maximum 6 images allowed');
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _uploadedImages.add(image));
    }
  }

  Future<void> _pickImageFromCamera() async {
    if (_uploadedImages.length >= 6) {
      _showMessage('Maximum 6 images allowed');
      return;
    }
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _uploadedImages.add(image));
    }
  }

  void _removeImage(int index) {
    setState(() => _uploadedImages.removeAt(index));
  }

  void _showMessage(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (_invalidCharsRegex.hasMatch(value)) {
      return '$fieldName cannot contain @, <, or >';
    }
    return null;
  }

  String? _validateOptional(String? value, String fieldName) {
    if (value != null && value.isNotEmpty && _invalidCharsRegex.hasMatch(value)) {
      return '$fieldName cannot contain @, <, or >';
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid number';
    }
    if (quantity <= 0) {
      return 'Quantity must be greater than 0';
    }
    if (quantity > 1000) {
      return 'Quantity seems too high (max 1000)';
    }
    return null;
  }

  Future<void> _submitDonation() async {
    // Validate form
    if (_formKey.currentState?.validate() != true) {
      _showMessage('Please fix the errors in the form', color: Colors.orange);
      return;
    }

    if (_selectedCondition == null) {
      _showMessage('Please select equipment condition', color: Colors.orange);
      return;
    }

    if (_uploadedImages.isEmpty) {
      _showMessage('Please add at least one photo', color: Colors.orange);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showMessage('Login required to submit', color: Colors.red);
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      FocusScope.of(context).unfocus();
      _showMessage('Submitting...', color: Colors.blue);
      final quantity = int.parse(_quantityController.text.trim());

      final service = DonationService();
      final item = await service.addDonation(
        itemName: _itemNameController.text.trim(),
        condition: _selectedCondition!,
        description: _descriptionController.text.trim(),
        quantity: quantity,
        location: _locationController.text.trim(),
        images: _uploadedImages,
      );

      if (!mounted) return;
      _showMessage('Donation submitted (pending review).', color: const Color(0xFF4CAF50));
      Navigator.pop(context, item);
    } on FirebaseException catch (e) {
      _showMessage('Failed: ${e.code} ${e.message}', color: Colors.red);
    } catch (e) {
      _showMessage('Failed: $e', color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003465),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Donation Form', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user == null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    border: Border.all(color: const Color(0xFFFFA726)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFFFFA726)),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Please log in to submit a donation.',
                          style: TextStyle(color: Color(0xFF8D6E63)),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Register', style: TextStyle(color: Color(0xFFFFA726))),
                      ),
                    ],
                  ),
                ),
              _itemNameField(),
              const SizedBox(height: 15),
              _conditionField(),
              const SizedBox(height: 15),
              _descriptionField(),
              const SizedBox(height: 15),
              _quantityField(),
              const SizedBox(height: 15),
              _locationField(),
              const SizedBox(height: 15),
              _photoButtons(),
              const SizedBox(height: 15),
              _imagePreview(),
              const SizedBox(height: 15),
              _actionButtons(),
              const SizedBox(height: 15),
              _infoNotice(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemNameField() => _labeled(
        'Item Name *',
        TextFormField(
          controller: _itemNameController,
          validator: (value) => _validateRequired(value, 'Item name'),
          decoration: InputDecoration(
            hintText: 'e.g., Manual Wheelchair',
            hintStyle: const TextStyle(color: Color(0xFFAAA6B2), fontSize: 16),
            prefixIcon: const Icon(Icons.inventory_2_outlined, color: Color(0xFFAAA6B2), size: 22),
            border: _outline(),
            enabledBorder: _outline(),
            errorBorder: _outline(color: Colors.red),
            focusedErrorBorder: _outline(color: Colors.red),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      );

  Widget _conditionField() => _labeled(
        'Equipment Condition *',
        DropdownButtonFormField<String>(
          value: _selectedCondition,
          hint: const Text('Select equipment condition', style: TextStyle(color: Color(0xFFAAA6B2))),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.verified_outlined, color: Color(0xFFAAA6B2), size: 22),
            border: _outline(radius: 11),
            enabledBorder: _outline(radius: 11),
            focusedBorder: _outline(radius: 11),
            errorBorder: _outline(radius: 11, color: Colors.red),
            focusedErrorBorder: _outline(radius: 11, color: Colors.red),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Equipment condition is required';
            }
            return null;
          },
          items: _conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (v) => setState(() => _selectedCondition = v),
        ),
      );

  Widget _descriptionField() => _labeled(
        'Description',
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          validator: (value) => _validateOptional(value, 'Description'),
          decoration: InputDecoration(
            hintText: 'Describe the equipment, its features, and notes (optional)',
            hintStyle: const TextStyle(color: Color(0xFFAAA6B2), fontSize: 16),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(bottom: 60),
              child: Icon(Icons.description_outlined, color: Color(0xFFAAA6B2), size: 22),
            ),
            border: _outline(radius: 11),
            enabledBorder: _outline(radius: 11),
            errorBorder: _outline(radius: 11, color: Colors.red),
            focusedErrorBorder: _outline(radius: 11, color: Colors.red),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      );

  Widget _quantityField() => _labeled(
        'Quantity *',
        TextFormField(
          controller: _quantityController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // فقط أرقام
          ],
          validator: _validateQuantity,
          decoration: InputDecoration(
            hintText: 'e.g., 1',
            hintStyle: const TextStyle(color: Color(0xFFAAA6B2), fontSize: 16),
            prefixIcon: const Icon(Icons.numbers, color: Color(0xFFAAA6B2), size: 22),
            border: _outline(radius: 11),
            enabledBorder: _outline(radius: 11),
            errorBorder: _outline(radius: 11, color: Colors.red),
            focusedErrorBorder: _outline(radius: 11, color: Colors.red),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          ),
        ),
      );

  Widget _locationField() => _labeled(
        'Location *',
        TextFormField(
          controller: _locationController,
          validator: (value) => _validateRequired(value, 'Location'),
          decoration: InputDecoration(
            hintText: 'Enter location',
            hintStyle: const TextStyle(color: Color(0xFFAAA6B2), fontSize: 16),
            prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFFAAA6B2), size: 22),
            border: _outline(radius: 11),
            enabledBorder: _outline(radius: 11),
            errorBorder: _outline(radius: 11, color: Colors.red),
            focusedErrorBorder: _outline(radius: 11, color: Colors.red),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          ),
        ),
      );

  Widget _photoButtons() => _labeled(
        'Add Photo *',
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickImageFromGallery,
                icon: const Icon(Icons.photo_library, color: Colors.white),
                label: const Text('From Gallery'),
                style: _photoButtonStyle(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _pickImageFromCamera,
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text('Take Photo'),
                style: _photoButtonStyle(),
              ),
            ),
          ],
        ),
      );

  Widget _imagePreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _uploadedImages.isEmpty ? Colors.red.shade300 : const Color(0xFFAAA6B2),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Images (${_uploadedImages.length}/6)',
                style: TextStyle(
                  color: _uploadedImages.isEmpty ? Colors.red.shade700 : const Color(0xFF8D8B92),
                  fontSize: 14,
                  fontWeight: _uploadedImages.isEmpty ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (_uploadedImages.isEmpty) ...[
                const SizedBox(width: 5),
                const Text(
                  '- Required',
                  style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          _uploadedImages.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'No images added yet - Please add at least one image',
                      style: TextStyle(color: Color(0xFF8D8B92), fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _uploadedImages.length,
                  itemBuilder: (context, index) {
                    final xfile = _uploadedImages[index];
                    return Stack(
                      children: [
                        FutureBuilder<Uint8List>(
                          future: xfile.readAsBytes(),
                          builder: (context, snap) {
                            if (snap.connectionState != ConnectionState.done) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(color: const Color(0xFF8E8B93)),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (!snap.hasData) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(11),
                                  border: Border.all(color: const Color(0xFF8E8B93)),
                                ),
                              );
                            }
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(color: const Color(0xFF8E8B93)),
                                image: DecorationImage(
                                  image: MemoryImage(snap.data!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _actionButtons() => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                side: const BorderSide(color: Color(0xFFFFA726)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFFFA726), fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: _submitDonation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003465),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                elevation: 2,
              ),
              child: const Text(
                'Submit Donation',
                style: TextStyle(color: Color(0xFFF7FBFF), fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );

  Widget _infoNotice() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFAAA6B2)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF003465), size: 24),
                const SizedBox(width: 15),
                const Expanded(
                  child: Text(
                    'Your donation will be reviewed by admin before being added to inventory',
                    style: TextStyle(color: Color(0xFFAAA6B2), fontSize: 15, height: 1.3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 5),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFFFA726), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '* Required fields cannot be empty',
                    style: TextStyle(color: Color(0xFFAAA6B2), fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _labeled(String label, Widget field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF003465), fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 9),
          field,
        ],
      );

  OutlineInputBorder _outline({double radius = 12, Color? color}) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: color ?? const Color(0xFFAAA6B2)),
      );

  ButtonStyle _photoButtonStyle() => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF003465),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      );
}

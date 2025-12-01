import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'reservation.dart';
import 'login.dart'; // Add this import for LoginPage
import 'signup.dart'; // Add this import for SignupPage
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // NEW
import 'profilePage.dart';

class DonationPage extends StatefulWidget {
  final String userName;
  const DonationPage({super.key, required this.userName});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false; // جديد: لتعقب محاولة الإرسال
  final ImagePicker _imagePicker = ImagePicker();

  // ==== Validation helpers (fixed regex) ====
  final RegExp _forbiddenChars = RegExp(r'[@<>]');
  final RegExp _scriptPattern = RegExp(
    r'\bscript\b',
    caseSensitive: false,
  ); // fixed
  final RegExp _urlPattern = RegExp(r'https?://');
  final RegExp _multiSpace = RegExp(r'\s{2,}');

  String? _validateText({
    required String? value,
    required String field,
    int min = 3,
    int max = 120,
    bool allowUrl = false,
    bool allowScript = false,
    bool forbidAt = true,
  }) {
    if (value == null) return 'Please enter $field';
    final v = value.trim();
    if (v.isEmpty) return 'Please enter $field';
    if (v.length < min) return '$field must be at least $min chars';
    if (v.length > max) return '$field must be <= $max chars';
    if (_multiSpace.hasMatch(v)) return 'Remove extra spaces in $field';
    if (forbidAt && _forbiddenChars.hasMatch(v))
      return '$field cannot contain @ < >';
    if (!allowScript && _scriptPattern.hasMatch(v))
      return 'Invalid word in $field';
    if (!allowUrl && _urlPattern.hasMatch(v))
      return 'Links are not allowed in $field';
    return null;
  }

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
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // NEW: upload images to Firebase Storage and return download URLs
  Future<List<String>> _uploadImages(String uid) async {
    final storage = FirebaseStorage.instance;
    final List<String> urls = [];
    for (int i = 0; i < selectedImages.length; i++) {
      final file = selectedImages[i];
      final path =
          'donations/$uid/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final ref = storage.ref().child(path);
      await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  // NEW: simple loading dialog while uploading
  Future<void> _showUploadingDialog(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: 14),
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // REPLACE: submit now uploads images to Storage then writes Firestore
  Future<void> _submitDonation() async {
    FocusScope.of(context).unfocus();
    if (!_submitted) setState(() => _submitted = true);
    if (_isSubmitting) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login before donating')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add at least one image')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _showUploadingDialog('Uploading photos...');
      final imageUrls = await _uploadImages(user.uid);
      if (mounted) Navigator.pop(context);

      final docRef = FirebaseFirestore.instance.collection('donations').doc();
      final donationId = docRef.id;

      await docRef.set({
        'donationId': donationId,
        'itemName': _itemNameController.text.trim(),
        'itemType': selectedEquipmentType,
        'condition': selectedCondition,
        'description': _descriptionController.text.trim(),
        'quantity': int.parse(_quantityController.text.trim()),
        'location': _locationController.text.trim(),
        'imageUrls': imageUrls,
        'status': 'pending',
        'submittedAt': Timestamp.now(),
        'donorId': user.uid,
      });

      showGeneralDialog(
        context: context,
        barrierColor: Colors.black54,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) => Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: DonationSubmittedDialog(
              onDone: () {
                Navigator.pop(context);
                _resetForm();
                setState(() => _isSubmitting = false);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/home',
                  (r) => false,
                );
              },
            ),
          ),
        ),
      );
    } catch (e) {
      // close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      selectedImages.clear();
      selectedEquipmentType = null;
      selectedCondition = null;
      _itemNameController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _quantityController.clear();
    });
  }

  Future<void> _pickImages() async {
    if (selectedImages.length >= 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Max 6 images')));
      return;
    }
    final pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final paths = selectedImages.map((f) => f.path).toSet();
      setState(() {
        for (final f in pickedFiles) {
          if (paths.length >= 6) break;
          if (!paths.contains(f.path)) {
            selectedImages.add(File(f.path));
            paths.add(f.path);
          }
        }
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        selectedImages.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  Color _getConditionColor(String? condition) {
    switch (condition) {
      case 'Excellent':
        return Theme.of(context).colorScheme.secondary;
      case 'Good':
        return Theme.of(context).colorScheme.primary;
      case 'Fair':
        return Colors.amberAccent;
      case 'Needs Repair':
        return Theme.of(context).colorScheme.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Care Center'), actions: [
          
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: FirebaseAuth.instance.currentUser == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // Close drawer first
                            Navigator.pop(context);
                            // Go to login (await if you want to react to result)
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                            // If login returned true (or something indicating updated state), refresh
                            if (result == true) {
                              setState(() {});
                            }
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(
                              'lib/images/default_profile.png',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Welcome, Guest!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        var data =
                            snapshot.data!.data() as Map<String, dynamic>;
                        String name = (data["name"] ?? "User").toString();
                        String? imageUrl = data["profileImage"] as String?;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // Close the drawer
                                Navigator.pop(context);

                                // Push ProfilePage and await result. ProfilePage should pop with true on success.
                                final updated = await Navigator.push<bool?>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ProfilePage(),
                                  ),
                                );

                                // If ProfilePage returned true (meaning profile was updated), refresh UI
                                if (updated == true) {
                                  setState(() {});
                                }
                              },
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    (imageUrl != null && imageUrl.isNotEmpty)
                                    ? NetworkImage(imageUrl)
                                    : const AssetImage(
                                            'lib/images/default_profile.png',
                                          )
                                          as ImageProvider,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Welcome, $name!",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),

            /// ---- MENU ITEMS ----
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventory Management'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Reservation & Rental'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text('Donation Management'),
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Tracking & Reports'),
              onTap: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FirebaseAuth.instance.currentUser != null
                  ? ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        // 1. Sign out
                        await FirebaseAuth.instance.signOut();

                        // 2. Close drawer
                        Navigator.pop(context);

                        // 3. Redirect to home (guest view)
                        Navigator.pushReplacementNamed(context, '/home');

                        // 4. Refresh the UI
                        setState(() {});
                      },
                    )
                  : SizedBox(), // if guest, hide logout
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      Theme.of(context).colorScheme.surface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Share Your Equipment',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Help those in need by donating assistive equipment',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              if (currentUser == null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock, color: Colors.orange.shade700),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You must login before submitting a donation.',
                          style: TextStyle(
                            color: Colors.orange.shade800,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ),
              _buildFormLabel('Item Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _itemNameController,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[@<>]')),
                ],
                decoration: _buildInputDecoration('e.g., Manual Wheelchair'),
                validator: (v) => _validateText(
                  value: v,
                  field: 'item name',
                  min: 3,
                  max: 100,
                ),
                onChanged: (_) {
                  if (_submitted) _formKey.currentState!.validate();
                },
              ),
              const SizedBox(height: 22),

              _buildFormLabel('Equipment Type'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedEquipmentType,
                hint: const Text('Select equipment type'),
                items: equipmentTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedEquipmentType = value),
                decoration: _buildInputDecoration('Select equipment type'),
                validator: (value) {
                  if (value == null) return 'Please select equipment type';
                  if (_forbiddenChars.hasMatch(value))
                    return 'Invalid characters';
                  return null;
                },
              ),
              const SizedBox(height: 22),

              _buildFormLabel('Equipment Condition'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCondition,
                hint: const Text('Select condition'),
                items: conditionStatus.map((c) {
                  final color = _getConditionColor(c);
                  return DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(c),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCondition = value),
                decoration: InputDecoration(
                  hintText: 'Select condition',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: selectedCondition != null
                          ? _getConditionColor(selectedCondition)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: selectedCondition != null
                          ? _getConditionColor(selectedCondition)
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: selectedCondition != null
                          ? _getConditionColor(selectedCondition)
                          : Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                ),
                validator: (value) =>
                    value == null ? 'Please select condition' : null,
              ),
              const SizedBox(height: 22),

              _buildFormLabel('Description'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: _buildInputDecoration('Describe the equipment...'),
                validator: (v) => _validateText(
                  value: v,
                  field: 'description',
                  min: 10,
                  max: 500,
                  allowUrl: false,
                  allowScript: false,
                ),
              ),
              const SizedBox(height: 22),

              _buildFormLabel('Quantity'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration('e.g., 1'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Please enter quantity';
                  if (_forbiddenChars.hasMatch(value))
                    return 'Invalid characters';
                  final n = int.tryParse(value);
                  if (n == null) return 'Quantity must be a number';
                  if (n <= 0) return 'Quantity must be > 0';
                  if (n > 1000) return 'Quantity too large';
                  return null;
                },
              ),
              const SizedBox(height: 22),

              _buildFormLabel('Pickup Location'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: _buildInputDecoration('Enter location or address'),
                validator: (v) => _validateText(
                  value: v,
                  field: 'location',
                  min: 3,
                  max: 150,
                ),
              ),
              const SizedBox(height: 24),

              _buildFormLabel('Add Photos'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.image),
                      label: const Text('From Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImageFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (selectedImages.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        color: Colors.grey.shade400,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No images selected',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add photos to showcase your donation',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selectedImages.length} image(s) selected',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Images (${selectedImages.length}/6)',
                      style: TextStyle(
                        fontSize: 12,
                        color: selectedImages.length >= 6
                            ? Colors.red
                            : Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: selectedImages.length,
                      itemBuilder: (context, index) => Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.error,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 28),
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                Navigator.pop(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          foregroundColor: Colors.grey.shade800,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Submit Button
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitDonation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Submit Donation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your donation will be reviewed by admin before being added to inventory.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 0.3,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error,
          width: 1,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }
}

class DonationSubmittedDialog extends StatelessWidget {
  final VoidCallback onDone;
  const DonationSubmittedDialog({super.key, required this.onDone});
  @override
  Widget build(BuildContext context) {
    final successColor = Theme.of(context).colorScheme.primary;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.blue, size: 56),
            const SizedBox(height: 24),
            Text(
              'Donation Submitted!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: successColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: successColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Pending Admin Review',
                style: TextStyle(
                  color: successColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Thank you! Please wait for admin approval.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: successColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

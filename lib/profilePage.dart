import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _picker = ImagePicker();
  File? _pickedImageFile; // mobile file
  Uint8List? _pickedImageBytes; // web bytes
  String? _profileImageUrl; // URL from Firestore
  bool _loading = false;

  final _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    if (_uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        _nameController.text = (data['name'] ?? '') as String;
        _emailController.text = (data['email'] ?? '') as String;
        _contactController.text = (data['contact'] ?? '') as String;
        setState(() {
          _profileImageUrl = (data['profilePicture'] ?? null) as String?;
        });
      }
    } catch (e) {
      // ignore load error; show optional message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load profile')));
    }
  }

  // Pick image (camera or gallery)
  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1200,
      imageQuality: 80,
    );
    if (picked == null) return;

    if (kIsWeb) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _pickedImageBytes = bytes;
        _pickedImageFile = null;
      });
    } else {
      setState(() {
        _pickedImageFile = File(picked.path);
        _pickedImageBytes = null;
      });
    }
  }

  // upload image to Firebase Storage and return download URL
  Future<String> _uploadImageAndGetUrl() async {
    if (_uid == null) throw Exception('Not authenticated');

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profilePictures')
        .child('$_uid.jpg');

    if (kIsWeb) {
      if (_pickedImageBytes == null) throw Exception('No image bytes');
      final uploadTask = await storageRef.putData(
        _pickedImageBytes!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final url = await uploadTask.ref.getDownloadURL();
      return url;
    } else {
      if (_pickedImageFile == null) throw Exception('No file selected');
      final uploadTask = await storageRef.putFile(
        _pickedImageFile!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final url = await uploadTask.ref.getDownloadURL();
      return url;
    }
  }

  // Save profile (uploads image if new, then updates Firestore)
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (_uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not authenticated')));
      return;
    }

    setState(() => _loading = true);

    try {
      String? newImageUrl;
      // If user picked a new image, upload it and get the URL
      if (_pickedImageBytes != null || _pickedImageFile != null) {
        newImageUrl = await _uploadImageAndGetUrl();
      }

      final updateData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'contact': _contactController.text.trim(),
      };

      if (newImageUrl != null) updateData['profilePicture'] = newImageUrl;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .update(updateData);

      // reflect changes locally
      if (newImageUrl != null) {
        _profileImageUrl = newImageUrl;
        _pickedImageFile = null;
        _pickedImageBytes = null;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile updated')));
      // Pop back with success
      Navigator.pop(context, true);
      setState(() {});
    } catch (e) {
      final msg = e.toString();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Update failed: $msg')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildAvatar() {
    // priority: preview picked image > stored URL > default asset
    if (_pickedImageBytes != null) {
      return CircleAvatar(
        radius: 55,
        backgroundImage: MemoryImage(_pickedImageBytes!),
      );
    } else if (_pickedImageFile != null) {
      return CircleAvatar(
        radius: 55,
        backgroundImage: FileImage(_pickedImageFile!),
      );
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 55,
        backgroundImage: NetworkImage(_profileImageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: 55,
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.person, size: 60, color: Colors.grey),
      );
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // colors from your theme / earlier examples
    const headerColor = Color(0xFF003465);
    const accentColor = Color(0xFF11497C);
    const dangerColor = Color(0xFFE65D57);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text('PROFILE'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // avatar + edit icon
            Center(
              child: Stack(
                children: [
                  _buildAvatar(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImageSourceActionSheet,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: accentColor,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),
            const Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 22,
                color: headerColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Full Name'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Full name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Please enter name'
                        : null,
                  ),

                  const SizedBox(height: 16),
                  const Text('Email'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Please enter email';
                      final emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(v.trim()))
                        return 'Enter valid email';
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  const Text('Phone Number'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _contactController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Please enter contact';
                      final contactRegex = RegExp(r'^[0-9+\s-]{6,20}$');
                      if (!contactRegex.hasMatch(v.trim()))
                        return 'Enter valid phone';
                      return null;
                    },
                  ),

                  const SizedBox(height: 26),

                  // buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _loading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: headerColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Update'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _loading
                              ? null
                              : () {
                                  // reset picked image preview and inputs to last saved values
                                  _pickedImageBytes = null;
                                  _pickedImageFile = null;
                                  _loadUserData();
                                  Navigator.pop(context, true);
                                  setState(() {});
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: dangerColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                    ],
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
}

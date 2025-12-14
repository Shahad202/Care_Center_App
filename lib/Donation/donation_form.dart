import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'donation_service.dart';
import 'donation_item.dart';

class DonationFormPage extends StatefulWidget {
  const DonationFormPage({super.key});

  @override
  State<DonationFormPage> createState() => _DonationFormPageState();
}

class _DonationFormPageState extends State<DonationFormPage> {
  final _formKey = GlobalKey<FormState>();           // For form validation
  final _itemNameController = TextEditingController();     // Item name input
  final _descriptionController = TextEditingController();  // Description input
  final _quantityController = TextEditingController();     // Quantity input
  final _locationController = TextEditingController();     // Location input

  String? _selectedCondition;  // Dropdown: New, Like New, Good, Fair, Needs Repair
  String? _selectedIconKey;    // User's selected icon (wheelchair, walker, etc.)

  final List<String> _conditions = ['New', 'Like New', 'Good', 'Fair', 'Needs Repair'];
  final Map<String, Map<String, dynamic>> _iconOptions = {
    'wheelchair': {
      'icon': Icons.wheelchair_pickup,
      'label': 'Wheelchair',
    },
    'walker': {
      'icon': Icons.elderly,
      'label': 'Walker',
    },
    'crutches': {
      'icon': Icons.accessibility,
      'label': 'Crutches',
    },
    'shower_chair': {
      'icon': Icons.gas_meter,
      'label': 'Oxygen Machines',
    },
    'hospital_bed': {
      'icon': Icons.bed,
      'label': 'Hospital Bed',
    },
    'other': {
      'icon': Icons.volunteer_activism,
      'label': 'Other',
    },
  };

  final RegExp _invalidCharsRegex = RegExp(r'[@<>]');

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  Future<void> _submitDonation() async {
    // STEP 1: Validate the form fields
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    // STEP 2: Check if icon is selected
    if (_selectedIconKey == null) {
      _showMessage('Please select an icon for the item.', color: Colors.red);
      return;
    }
    
    // STEP 3: Authentication check - redirect to login if not logged in
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      // STEP 4: Parse quantity from text field and ensure it's > 0
      final qtyText = _quantityController.text.trim();
      int qty = int.tryParse(qtyText) ?? 1;
      
      // Ensure quantity is valid (must be > 0)
      if (qty <= 0) {
        qty = 1;
      }
      
      final itemName = _itemNameController.text.trim();
      
      // STEP 5: Call DonationService to save to Firestore
      final donation = await DonationService().addDonation(
        itemName: itemName,
        condition: _selectedCondition ?? 'Good',
        description: _descriptionController.text.trim(),
        quantity: qty,
        location: _locationController.text.trim(),
        iconKey: _selectedIconKey!,
      );
      
      // STEP 6: Show success message
      _showMessage('Donation submitted successfully!', color: Colors.green);
      
      // STEP 7: Return to previous screen with the donation result
      if (mounted) Navigator.pop(context, donation);
      
    } catch (e) {
      // STEP 8: Handle errors and show error message
      _showMessage('Error: $e', color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      // Shows login screen if user not authenticated
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF003465).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 60,
                  color: Color(0xFF003465),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Login Required',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF003465),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Please log in to your account to make a donation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFAAA6B2),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003465),
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Go to Login',
                  style: TextStyle(
                    color: Color(0xFFF7FBFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 15),
                  side: const BorderSide(color: Color(0xFFFFA726)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(
                    color: Color(0xFFFFA726),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Donate Equipment')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _labeled(
                'Item Name *',
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Wheelchair',
                    border: _outline(),
                    focusedBorder: _outline(color: const Color(0xFF003465)),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Item name is required';
                    if (_invalidCharsRegex.hasMatch(v)) return 'Invalid characters not allowed';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              _labeled(
                'Condition *',
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  decoration: InputDecoration(border: _outline()),
                  items: _conditions
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedCondition = v),
                  validator: (v) => v == null ? 'Please select condition' : null,
                ),
              ),
              const SizedBox(height: 16),
              _labeled(
                'Quantity *',
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: '1',
                    border: _outline(),
                    focusedBorder: _outline(color: const Color(0xFF003465)),
                  ),
                  validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n <= 0) return 'Enter a valid quantity';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              _labeled(
                'Location *',
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: 'City / Area',
                    border: _outline(),
                    focusedBorder: _outline(color: const Color(0xFF003465)),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Location is required';
                    if (_invalidCharsRegex.hasMatch(v)) return 'Invalid characters not allowed';
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              _labeled(
                'Description',
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Additional details (optional)',
                    border: _outline(),
                    focusedBorder: _outline(color: const Color(0xFF003465)),
                  ),
                  validator: (v) =>
                      v != null && _invalidCharsRegex.hasMatch(v) ? 'Invalid characters not allowed' : null,
                ),
              ),
              const SizedBox(height: 20),
              _iconSelector(),
              const SizedBox(height: 24),
              _actionButtons(),
              const SizedBox(height: 16),
              _infoNotice(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconSelector() => _labeled(
        'Choose Item Icon *',
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _iconOptions.entries.map((entry) {
            final selected = _selectedIconKey == entry.key;
            final iconData = entry.value['icon'] as IconData;
            final label = entry.value['label'] as String;
            
            return GestureDetector(
              onTap: () => setState(() => _selectedIconKey = entry.key),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFF003465) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected ? const Color(0xFF003465) : const Color(0xFFE0E3E7),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF003465).withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      iconData,
                      color: selected ? Colors.white : const Color(0xFF003465),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 70,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: selected ? const Color(0xFF003465) : const Color(0xFF666666),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );

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
}

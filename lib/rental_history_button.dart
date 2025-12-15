import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project444/rental_history_view.dart';

/// Reusable Rental History Icon Button for app bars
/// Automatically detects user role and shows:
/// - User-specific rental history for regular users
/// - All rentals for admins
class RentalHistoryButton extends StatefulWidget {
  final bool? showUserOnly; // Optional override

  const RentalHistoryButton({
    Key? key,
    this.showUserOnly,
  }) : super(key: key);

  @override
  State<RentalHistoryButton> createState() => _RentalHistoryButtonState();
}

class _RentalHistoryButtonState extends State<RentalHistoryButton> {
  String _userRole = 'user';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) {
        setState(() {
          _userRole = 'guest';
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      
      if (snap.exists) {
        final role = (snap.data()?['role'] ?? 'user').toString().toLowerCase();
        if (mounted) {
          setState(() {
            _userRole = role;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _userRole = 'user';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user role: $e');
      if (mounted) {
        setState(() {
          _userRole = 'user';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If still loading, show a simple icon without interaction
    if (_isLoading) {
      return Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }

    // Determine if we should show only user's rentals
    // Priority: widget.showUserOnly override > role-based logic
    bool showUserOnly;
    if (widget.showUserOnly != null) {
      showUserOnly = widget.showUserOnly!;
    } else {
      // Admin sees all, users see only their own
      showUserOnly = _userRole != 'admin';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RentalHistoryView(showUserOnly: showUserOnly),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.history,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
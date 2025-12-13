import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project444/inventory/inventory_admin.dart';
import 'package:project444/login.dart';
import 'package:project444/profilePage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project444/rental_history_button.dart';
import 'package:project444/common_drawer.dart';
import 'admin_pending_donations.dart';
import 'inventory/inventory_admin.dart';
import 'inventory/inventory_guest.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _userRole = 'guest';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final role = (snap.data()?['role'] ?? 'user').toString();
      if (mounted) setState(() => _userRole = role);
    } catch (_) {
      // keep default role
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      drawer: CommonDrawer(
        userRole: _userRole,
        onRoleUpdated: () {
          _loadUserRole();
        },
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(63),
        child: AppBar(
          backgroundColor: const Color(0xFF003465),
          elevation: 0,
          toolbarHeight: 63,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 24),
              tooltip: 'Open menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const SizedBox.shrink(),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: RentalHistoryButton(showUserOnly: false),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Admin',
                      style: TextStyle(
                        color: Color(0xFF003465),
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Manage donations, inventory, and reports',
                      style: TextStyle(
                        color: Color(0xFFAAA6B2),
                        fontSize: 16,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _dashboardCard(
                      title: 'Pending Donations',
                      subtitle: 'Review and approve donations',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminPendingDonations()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _dashboardCard(
                      title: 'Inventory Management',
                      subtitle: _userRole.toLowerCase() == 'admin'
                          ? 'Manage all items in inventory'
                          : 'Browse available items',
                      onTap: () {
                        final role = _userRole.toLowerCase();
                        if (role == 'admin') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => NewinventoryWidget()),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => UserInventoryWidget())),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    _dashboardCard(
                      title: 'Reports & Analytics',
                      subtitle: 'View donation and rental statistics',
                      onTap: () {
                        Navigator.pushNamed(context, '/reports');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashboardCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    var isPressed = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return AnimatedScale(
          scale: isPressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
              onHighlightChanged: (value) => setState(() => isPressed = value),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF9FBFF), Color(0xFFF4F7FB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: const Color(0xFF8EA4BD),
                    width: 1.4,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.06),
                      offset: Offset(0, 3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF003465),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: Color(0xFF7A869A),
                              fontSize: 14,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF003465),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

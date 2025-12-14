import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project444/login.dart';
import 'package:project444/profilePage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'admin_pending_donations.dart';
import 'navigation_transitions.dart';

import 'admin_reservation_details.dart';
import 'admin_pending_reservations.dart';

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
      final snap = await FirebaseFirestore.instance.collection('users').doc(uid).get();
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF003465)),
              child: FirebaseAuth.instance.currentUser == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            final result = await Navigator.push(
                              context,
                              slideUpRoute(const LoginPage()),
                            );
                            if (result == true && mounted) {
                              setState(() {});
                            }
                          },
                          child: const CircleAvatar(
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
                        _userRole = (data['role'] ?? 'user').toString();

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                final updated = await Navigator.push<bool?>(
                                  context,
                                  slideUpRoute(const ProfilePage()),
                                );
                                if (updated == true && mounted) {
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
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                final role = _userRole.toLowerCase();
                if (role == 'admin') {
                  Navigator.pushReplacementNamed(context, '/admin');
                } else {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
            ),
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
              title: const Text('Donations'),
              onTap: () {
                Navigator.pushNamed(context, '/donor');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Tracking & Reports'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/reports');
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FirebaseAuth.instance.currentUser != null
                  ? ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    )
                  : const SizedBox(),
            ),
          ],
        ),
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
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                          slideUpRoute(const AdminPendingDonations()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _dashboardCard(
                      title: 'Reservation Management',
                      subtitle: 'Manage items in reservation',
                      onTap: () {
                        Navigator.push(
                          context,
                          slideUpRoute(AdminPendingReservations()),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _dashboardCard(
                      title: 'Reports & Analytics',
                      subtitle: 'View donation and rental statistics',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Coming soon...')),
                        );
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
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
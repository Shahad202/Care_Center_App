import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project444/login.dart';
import 'package:project444/profilePage.dart';
import 'admin_pending_donations.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
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

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                final updated = await Navigator.push<bool?>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ProfilePage(),
                                  ),
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
                Navigator.pushReplacementNamed(context, '/home');
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
              onTap: () => Navigator.pop(context),
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
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF003465),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Admin',
              style: TextStyle(
                color: Color(0xFF003465),
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage donations, inventory, and reports',
              style: TextStyle(
                color: Color(0xFF7A869A),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            _buildDashboardCard(
              context,
              title: 'Pending Donations',
              subtitle: 'Review and approve donations',
              icon: Icons.volunteer_activism,
              color: const Color(0xFF1874CF),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminPendingDonations(),
                  ),
                );
              },
            ),
            const SizedBox(height: 14),
            _buildDashboardCard(
              context,
              title: 'Inventory Management',
              subtitle: 'Manage items in inventory',
              icon: Icons.inventory_2,
              color: const Color(0xFF4CAF50),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon...')),
                );
              },
            ),
            const SizedBox(height: 14),
            _buildDashboardCard(
              context,
              title: 'Reports & Analytics',
              subtitle: 'View donation and rental statistics',
              icon: Icons.bar_chart,
              color: const Color(0xFFFFA726),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.12), color.withOpacity(0.06)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF003465).withOpacity(0.08),
                offset: const Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF003465),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF7A869A),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
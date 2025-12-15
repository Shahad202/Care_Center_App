import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'profilePage.dart';
import 'package:project444/rental_history_button.dart';
import 'package:project444/rental_history_view.dart';

/// Reusable drawer widget that can be used across all pages
/// Automatically updates based on user role and authentication state
class CommonDrawer extends StatelessWidget {
  final String userRole;
  final VoidCallback? onRoleUpdated;

  const CommonDrawer({
    Key? key,
    required this.userRole,
    this.onRoleUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                          if (result == true) {
                            onRoleUpdated?.call();
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

                      var data = snapshot.data!.data() as Map<String, dynamic>;
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
                              if (updated == true) {
                                onRoleUpdated?.call();
                              }
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  (imageUrl != null && imageUrl.isNotEmpty)
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage(
                                          'lib/images/default_profile.png',
                                        ) as ImageProvider,
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
              final role = userRole.toLowerCase();
              if (role == 'admin') {
                Navigator.pushReplacementNamed(context, '/admin');
              } else {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text(
              'Inventory Management',
              style: TextStyle(fontSize: 14),
            ),
            onTap: () {
              Navigator.pop(context);
              final role = userRole.toLowerCase();
              if (role == 'admin') {
                Navigator.pushReplacementNamed(context, '/inventory_admin');
              } else {
                Navigator.pushReplacementNamed(context, '/inventory');
              }
            },
          ),
          // يظهر فقط لـ renter و admin
          if (userRole.toLowerCase() == 'renter' || userRole.toLowerCase() == 'admin')
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text(
                'Reservation & Rental',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/renter');
              },
            ),
          // يظهر فقط لـ donor و admin
          if (userRole.toLowerCase() == 'donor' || userRole.toLowerCase() == 'admin')
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text('Donations', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/donor');
              },
            ),
          // Tracking & Reports للـ admin فقط
          if (userRole.toLowerCase() == 'admin')
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text(
                'Tracking & Reports',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/reports');
              },
            ),
          // Tracking للـ donor و renter فقط
          if (userRole.toLowerCase() == 'donor' || userRole.toLowerCase() == 'renter')
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text(
                'My Rentals',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                // استخدم RentalHistoryView مباشرة
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RentalHistoryView(showUserOnly: true),
                  ),
                );
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
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
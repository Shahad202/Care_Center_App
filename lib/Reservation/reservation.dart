import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project444/signup.dart';
import 'package:project444/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project444/firebase_options.dart';
import 'package:project444/Reservation/reservation.dart';
import 'package:project444/donation/donor_page.dart';
import 'package:project444/profilePage.dart';
import 'dart:math' as math;
import 'package:project444/Reservation/reservation_tabs.dart';

class RenterPage extends StatefulWidget {
  final String? userName;
  const RenterPage({super.key, this.userName});

  @override
  State<RenterPage> createState() => _RenterPageState();
}

class _RenterPageState extends State<RenterPage> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          _buildTabBar(),
          const SizedBox(height: 30),
          Expanded(child: SingleChildScrollView(child: _buildTabContent())),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 63,
      width: double.infinity,
      color: const Color(0xFF003465),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              padding: const EdgeInsets.all(18),
              constraints: const BoxConstraints(),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: FirebaseAuth.instance.currentUser == null
                ? _guestDrawerHeader()
                : _userDrawerHeader(),
          ),
          _drawerMenu(),
        ],
      ),
    );
  }

  Widget _guestDrawerHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            Navigator.pop(context);
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            if (result == true) setState(() {});
          },
          child: const CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage('lib/images/default_profile.png'),
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
    );
  }

  Widget _tabBtn(String label, int index) {
    final selected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: selected
              ? [
                  const BoxShadow(
                    color: Color(0x14000000),
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ]
              : null,
          color: selected ? const Color(0xFF003465) : const Color(0xFFF7FBFF),
          border: selected
              ? null
              : Border.all(color: const Color(0xFFAAA6B2), width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFFF7FBFF) : const Color(0xFFAAA6B2),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const HowItWorksTab();
      case 1:
        return const browsePage();
      case 2:
        return const TrackingPage();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _userDrawerHeader() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
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
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
                if (updated == true) setState(() {});
              },
              child: CircleAvatar(
                radius: 35,
                backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                    ? NetworkImage(imageUrl)
                    : const AssetImage('lib/images/default_profile.png')
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
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(child: _tabBtn('How It Works', 0)),
          const SizedBox(width: 12),
          Expanded(child: _tabBtn('Browse', 1)),
          const SizedBox(width: 12),
          Expanded(child: _tabBtn('Tracking', 2)),
        ],
      ),
    );
  }

  Widget _drawerMenu() {
    return Column(
      children: [
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
        if (FirebaseAuth.instance.currentUser != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
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
                setState(() {});
              },
            ),
          ),
      ],
    );
  }
}


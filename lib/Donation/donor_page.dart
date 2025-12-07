import 'package:flutter/material.dart';
import 'donate_tab.dart';
import 'tracking_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project444/signup.dart';
import 'package:project444/login.dart';
import 'package:project444/profilePage.dart';


class DonorPage extends StatefulWidget {
  final String? userName;
  const DonorPage({super.key, this.userName});
  
  @override
  State<DonorPage> createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  int _selectedTabIndex = 0;  // 0=About, 1=Donate, 2=Tracking
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
              decoration: const BoxDecoration(
                color: Color(0xFF003465),
              ),
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
                        _userRole = (data['role'] ?? 'user').toString();

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
              title: const Text(
                'Inventory Management',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text(
                'Reservation & Rental',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/inventory');
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text('Donations', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/donor');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text(
                'Tracking & Reports',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
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
    
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          _buildTabBar(),
          const SizedBox(height: 30),
          Expanded(
            child: _selectedTabIndex == 2
                ? const TrackingTabPage()
                : SingleChildScrollView(child: _buildTabContent()),
          ),
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
          const SizedBox(width: 8),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              padding: const EdgeInsets.all(18),
              constraints: const BoxConstraints(),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Menu',
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(child: _tabBtn('About', 0)),
          const SizedBox(width: 12),
          Expanded(child: _tabBtn('Donate', 1)),
          const SizedBox(width: 12),
          Expanded(child: _tabBtn('Tracking', 2)),
        ],
      ),
    );
  }

  Widget _tabBtn(String label, int index) {
    final selected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),  // Switch tabs
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: selected
              ? [const BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 6)]
              : null,
          // Selected: Dark blue with shadow
          // Unselected: Light background with border
          color: selected ? const Color(0xFF003465) : const Color(0xFFF7FBFF),
          border: selected ? null : Border.all(color: const Color(0xFFAAA6B2), width: 1),
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
        return _buildAboutContent();
      case 1:
        return DonateTabPage(onDonationAdded: (_) {});
      case 2:
        return const SizedBox.shrink();
      default:
        return _buildAboutContent();
    }
  }

  Widget _buildAboutContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _makeDifferenceCard(),      // "Make a Difference" banner
          const SizedBox(height: 30),
          _howItWorks(),              // 3-step process explanation
          const SizedBox(height: 30),
          _beforeDonateCard(),        // 4-point checklist
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _makeDifferenceCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x14003465), offset: Offset(0, 6), blurRadius: 16),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF003465), Color(0xFF1874CF)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Make a Difference',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Your donated equipment can change someone's life.",
            style: TextStyle(
              color: Color(0xFFEAF2FA),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _howItWorks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How It Works',
          style: TextStyle(color: Color(0xFF003465), fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 30),
        
        // Step 1
        _stepCard(
          'lib/images/Level1.png',
          'Submit Your Donation',
          'Fill out the donation form with equipment details and photos',
        ),
        const SizedBox(height: 30),
        
        // Step 2
        _stepCard(
          'lib/images/2circled.png',
          'Admin Review',
          'Our team will review your submission within 24-48 hours',
        ),
        const SizedBox(height: 30),
        
        // Step 3
        _stepCard(
          'lib/images/Circled3.png',
          'Help Someone',
          'Once approved, your equipment will be available for those in need',
        ),
      ],
    );
  }

  Widget _stepCard(String img, String title, String desc) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        boxShadow: const [BoxShadow(color: Color(0x10000000), offset: Offset(0, 2), blurRadius: 4)],
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon/Image (49x49)
          Container(
            width: 49,
            height: 49,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(img), fit: BoxFit.contain),
            ),
          ),
          const SizedBox(width: 10),
          
          // Title + Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF003465),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _beforeDonateCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFFFF1DE),
        border: Border.all(color: const Color.fromARGB(255, 250, 176, 72), width: 1.85),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Before You Donate',
            style: TextStyle(
              color: Color.fromARGB(255, 56, 55, 55),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _bullet('Ensure the equipment is clean and in working condition.'),
          const SizedBox(height: 16),
          _bullet('Provide clear, well-lit photos from multiple angles.'),
          const SizedBox(height: 16),
          _bullet('Be honest about the equipment condition and any defects.'),
          const SizedBox(height: 16),
          _bullet('Include all accessories and user manuals if available.'),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8.5,
          height: 8.5,
          margin: const EdgeInsets.only(top: 7),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(212, 133, 18, 1),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
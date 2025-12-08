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












// class RenterPage extends StatefulWidget {
//   final String? userName;
//   const RenterPage({super.key, this.userName});

//   @override
//   State<RenterPage> createState() => _RenterPageState();
// }

// class _RenterPageState extends State<RenterPage> {
//   int _selectedTabIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7FBFF),
//       drawer: _buildDrawer(),
//       body: Column(
//         children: [
//           _buildHeader(),
//           const SizedBox(height: 8),
//           _buildTabBar(),
//           const SizedBox(height: 30),
//           Expanded(
//             child: SingleChildScrollView(
//               child: _buildTabContent(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Header -----------------
//   Widget _buildHeader() {
//     return Container(
//       height: 63,
//       width: double.infinity,
//       color: const Color(0xFF003465),
//       child: Row(
//         children: [
//           Builder(
//             builder: (context) => IconButton(
//               icon: const Icon(Icons.menu, color: Colors.white),
//               padding: const EdgeInsets.all(18),
//               constraints: const BoxConstraints(),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Drawer -----------------
//   Widget _buildDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             child: FirebaseAuth.instance.currentUser == null
//                 ? _guestDrawerHeader()
//                 : _userDrawerHeader(),
//           ),
//           _drawerMenu(),
//         ],
//       ),
//     );
//   }

//   Widget _guestDrawerHeader() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         GestureDetector(
//           onTap: () async {
//             Navigator.pop(context);
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const LoginPage()),
//             );
//             if (result == true) setState(() {});
//           },
//           child: const CircleAvatar(
//             radius: 35,
//             backgroundImage: AssetImage('lib/images/default_profile.png'),
//           ),
//         ),
//         const SizedBox(height: 10),
//         const Text(
//           "Welcome, Guest!",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _userDrawerHeader() {
//     return FutureBuilder<DocumentSnapshot>(
//       future: FirebaseFirestore.instance
//           .collection("users")
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .get(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(color: Colors.white),
//           );
//         }

//         var data = snapshot.data!.data() as Map<String, dynamic>;
//         String name = (data["name"] ?? "User").toString();
//         String? imageUrl = data["profileImage"] as String?;

//         return Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 Navigator.pop(context);
//                 final updated = await Navigator.push<bool?>(
//                   context,
//                   MaterialPageRoute(builder: (_) => const ProfilePage()),
//                 );
//                 if (updated == true) setState(() {});
//               },
//               child: CircleAvatar(
//                 radius: 35,
//                 backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
//                     ? NetworkImage(imageUrl)
//                     : const AssetImage('lib/images/default_profile.png')
//                         as ImageProvider,
//               ),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "Welcome, $name!",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _drawerMenu() {
//     return Column(
//       children: [
//         ListTile(
//           leading: const Icon(Icons.inventory),
//           title: const Text('Inventory Management'),
//           onTap: () => Navigator.pop(context),
//         ),
//         ListTile(
//           leading: const Icon(Icons.calendar_month),
//           title: const Text('Reservation & Rental'),
//           onTap: () => Navigator.pop(context),
//         ),
//         ListTile(
//           leading: const Icon(Icons.volunteer_activism),
//           title: const Text('Donation Management'),
//           onTap: () {
//             Navigator.pushNamed(context, '/login');
//           },
//         ),
//         ListTile(
//           leading: const Icon(Icons.bar_chart),
//           title: const Text('Tracking & Reports'),
//           onTap: () => Navigator.pop(context),
//         ),
//         if (FirebaseAuth.instance.currentUser != null)
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ListTile(
//               leading: const Icon(Icons.logout, color: Colors.red),
//               title: const Text(
//                 "Logout",
//                 style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//               ),
//               onTap: () async {
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.pop(context);
//                 Navigator.pushReplacementNamed(context, '/home');
//                 setState(() {});
//               },
//             ),
//           ),
//       ],
//     );
//   }

//   // ----------------- Tabs -----------------
//   Widget _buildTabBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Row(
//         children: [
//           Expanded(child: _tabBtn('How It Works', 0)),
//           const SizedBox(width: 12),
//           Expanded(child: _tabBtn('Browse', 1)),
//           const SizedBox(width: 12),
//           Expanded(child: _tabBtn('Tracking', 2)),
//         ],
//       ),
//     );
//   }

//   Widget _tabBtn(String label, int index) {
//     final selected = _selectedTabIndex == index;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedTabIndex = index),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(50),
//           boxShadow: selected
//               ? [const BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 6)]
//               : null,
//           color: selected ? const Color(0xFF003465) : const Color(0xFFF7FBFF),
//           border: selected ? null : Border.all(color: const Color(0xFFAAA6B2), width: 1),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         alignment: Alignment.center,
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? const Color(0xFFF7FBFF) : const Color(0xFFAAA6B2),
//             fontSize: 14,
//             fontFamily: 'Inter',
//           ),
//         ),
//       ),
//     );
//   }

//   // ----------------- Tab Content -----------------
//   Widget _buildTabContent() {
//     switch (_selectedTabIndex) {
//       case 0:
//         return _buildHowItWorks();
//       case 1:
//         return const ReservationTabPage(); // ✅ Use your reservation UI
//       case 2:
//         return _buildTracking();
//       default:
//         return const SizedBox.shrink();
//     }
//   }

  // Widget _buildHowItWorks() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       children: [
  //         _stepCard('lib/images/Level1.png', 'Check Availability', 'Select equipment and check available dates.'),
  //         const SizedBox(height: 30),
  //         _stepCard('lib/images/2circled.png', 'Reserve', 'Choose your date range or immediate pickup.'),
  //         const SizedBox(height: 30),
  //         _stepCard('lib/images/Circled3.png', 'Confirmation', 'Submit reservation and await admin approval.'),
  //         const SizedBox(height: 30),
  //         _stepCard('lib/images/4circled.png', 'Rental Lifecycle', 'Track status: Reserved → Checked Out → Returned → Maintenance.'),
  //       ],
  //     ),
  //   );
  // }

//   Widget _stepCard(String img, String title, String desc) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(11),
//         boxShadow: const [BoxShadow(color: Color(0x10000000), offset: Offset(0, 2), blurRadius: 4)],
//         color: Colors.white,
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(width: 49, height: 49, decoration: BoxDecoration(image: DecorationImage(image: AssetImage(img), fit: BoxFit.contain))),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: const TextStyle(color: Color(0xFF003465), fontSize: 16, fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 6),
//                 Text(desc, style: const TextStyle(color: Color(0xFF777777), fontSize: 14, height: 1.4)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTracking() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Text("Track your reservations and status here..."),
//     );
//   }
// }

// // ----------------- ReservationTabPage (Browse) -----------------
// class ReservationTabPage extends StatelessWidget {
//   const ReservationTabPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const SizedBox(height: 20),
//           _buildReserveEquipmentCard(),
//           const SizedBox(height: 38),
//           _buildAvailableEquipmentSection(),
//           const SizedBox(height: 38),
//           _buildBrowseButton(context),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }



// class RenterPage extends StatefulWidget {
//   final String? userName;
//   const RenterPage({super.key, this.userName});

//   @override
//   State<RenterPage> createState() => _RenterPageState();
// }

// class _RenterPageState extends State<RenterPage> {
//   int _selectedTabIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7FBFF),
//       drawer: _buildDrawer(),
//       body: Column(
//         children: [
//           _buildHeader(),
//           const SizedBox(height: 8),
//           _buildTabBar(),
//           const SizedBox(height: 30),
//           Expanded(
//             child: SingleChildScrollView(
//               child: _buildTabContent(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Header -----------------
//   Widget _buildHeader() {
//     return Container(
//       height: 63,
//       width: double.infinity,
//       color: const Color(0xFF003465),
//       child: Row(
//         children: [
//           Builder(
//             builder: (context) => IconButton(
//               icon: const Icon(Icons.menu, color: Colors.white),
//               padding: const EdgeInsets.all(18),
//               constraints: const BoxConstraints(),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Drawer -----------------
//   Widget _buildDrawer() {
//     return Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               child: FirebaseAuth.instance.currentUser == null
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () async {
//                             // Close drawer first
//                             Navigator.pop(context);
//                             // Go to login (await if you want to react to result)
//                             final result = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const LoginPage(),
//                               ),
//                             );
//                             // If login returned true (or something indicating updated state), refresh
//                             if (result == true) {
//                               setState(() {});
//                             }
//                           },
//                           child: CircleAvatar(
//                             radius: 35,
//                             backgroundImage: AssetImage(
//                               'lib/images/default_profile.png',
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         const Text(
//                           "Welcome, Guest!",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     )
//                   : FutureBuilder<DocumentSnapshot>(
//                       future: FirebaseFirestore.instance
//                           .collection("users")
//                           .doc(FirebaseAuth.instance.currentUser!.uid)
//                           .get(),
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) {
//                           return const Center(
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                             ),
//                           );
//                         }

//                         var data =
//                             snapshot.data!.data() as Map<String, dynamic>;
//                         String name = (data["name"] ?? "User").toString();
//                         String? imageUrl = data["profileImage"] as String?;

//                         return Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () async {
//                                 // Close the drawer
//                                 Navigator.pop(context);

//                                 // Push ProfilePage and await result. ProfilePage should pop with true on success.
//                                 final updated = await Navigator.push<bool?>(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => const ProfilePage(),
//                                   ),
//                                 );

//                                 // If ProfilePage returned true (meaning profile was updated), refresh UI
//                                 if (updated == true) {
//                                   setState(() {});
//                                 }
//                               },
//                               child: CircleAvatar(
//                                 radius: 35,
//                                 backgroundImage:
//                                     (imageUrl != null && imageUrl.isNotEmpty)
//                                     ? NetworkImage(imageUrl)
//                                     : const AssetImage(
//                                             'lib/images/default_profile.png',
//                                           )
//                                           as ImageProvider,
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               "Welcome, $name!",
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//             ),

//             /// ---- MENU ITEMS ----
//             ListTile(
//               leading: const Icon(Icons.inventory),
//               title: const Text('Inventory Management'),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.calendar_month),
//               title: const Text('Reservation & Rental'),
//               onTap: () => Navigator.pop(context),
//             ),
//             ListTile(
//               leading: const Icon(Icons.volunteer_activism),
//               title: const Text('Donation Management'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/login');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.bar_chart),
//               title: const Text('Tracking & Reports'),
//               onTap: () => Navigator.pop(context),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: FirebaseAuth.instance.currentUser != null
//                   ? ListTile(
//                       leading: Icon(Icons.logout, color: Colors.red),
//                       title: Text(
//                         "Logout",
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       onTap: () async {
//                         // 1. Sign out
//                         await FirebaseAuth.instance.signOut();

//                         // 2. Close drawer
//                         Navigator.pop(context);

//                         // 3. Redirect to home (guest view)
//                         Navigator.pushReplacementNamed(context, '/home');

//                         // 4. Refresh the UI
//                         setState(() {});
//                       },
//                     )
//                   : SizedBox(), // if guest, hide logout
//             ),
//           ],
//         ),
//       );
//   }

//   // ----------------- Tabs -----------------
//   Widget _buildTabBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 15),
//       child: Row(
//         children: [
//           Expanded(child: _tabBtn('How It Works', 0)),
//           const SizedBox(width: 12),
//           Expanded(child: _tabBtn('Browse', 1)),
//           const SizedBox(width: 12),
//           Expanded(child: _tabBtn('Tracking', 2)),
//         ],
//       ),
//     );
//   }

//   Widget _tabBtn(String label, int index) {
//     final selected = _selectedTabIndex == index;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedTabIndex = index),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(50),
//           boxShadow: selected ? [const BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 6)] : null,
//           color: selected ? const Color(0xFF003465) : const Color(0xFFF7FBFF),
//           border: selected ? null : Border.all(color: const Color(0xFFAAA6B2), width: 1),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 10),
//         alignment: Alignment.center,
//         child: Text(
//           label,
//           style: TextStyle(
//             color: selected ? const Color(0xFFF7FBFF) : const Color(0xFFAAA6B2),
//             fontSize: 14,
//             fontFamily: 'Inter',
//           ),
//         ),
//       ),
//     );
//   }

//   // ----------------- Tab Content -----------------
//   Widget _buildTabContent() {
//     switch (_selectedTabIndex) {
//       case 0:
//         return _buildHowItWorks();
//       case 1:
//         return _buildBrowseEquipment();
//       case 2:
//         return _buildTracking();
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   // ----------------- How It Works -----------------
//   Widget _buildHowItWorks() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           _stepCard('lib/images/Level1.png', 'Check Availability', 'Select equipment and check available dates.'),
//           const SizedBox(height: 30),
//           _stepCard('lib/images/2circled.png', 'Reserve', 'Choose your date range or immediate pickup.'),
//           const SizedBox(height: 30),
//           _stepCard('lib/images/Circled3.png', 'Confirmation', 'Submit reservation and await admin approval.'),
//           const SizedBox(height: 30),
//           _stepCard('lib/images/4circled.png', 'Rental Lifecycle', 'Track status: Reserved → Checked Out → Returned → Maintenance.'),
//         ],
//       ),
//     );
//   }

//   Widget _stepCard(String img, String title, String desc) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(11),
//         boxShadow: const [BoxShadow(color: Color(0x10000000), offset: Offset(0, 2), blurRadius: 4)],
//         color: Colors.white,
//       ),
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(width: 49, height: 49, decoration: BoxDecoration(image: DecorationImage(image: AssetImage(img), fit: BoxFit.contain))),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: const TextStyle(color: Color(0xFF003465), fontSize: 16, fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 6),
//                 Text(desc, style: const TextStyle(color: Color(0xFF777777), fontSize: 14, height: 1.4)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ----------------- Browse Equipment -----------------
//   Widget _buildBrowseEquipment() {
//     return Column(
//       children: [
//         Expanded(
//          child: browsePage(),
// )
//       ],
//     );
//   }

//   // ----------------- Tracking -----------------
//   Widget _buildTracking() {
//     return Column(
//       children: const [
//         Text("Track your reservations and status here..."),
//       ],
//     );
//   }
// }



// class ReservationTabPage extends StatelessWidget {
//   const ReservationTabPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const SizedBox(height: 20),
//           _buildReserveEquipmentCard(),
//           const SizedBox(height: 38),
//           _buildAvailableEquipmentSection(),
//           const SizedBox(height: 38),
//           _buildBrowseButton(context),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }

//   Widget _buildReserveEquipmentCard() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x14003465),
//             offset: Offset(0, 6),
//             blurRadius: 16,
//           ),
//         ],
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF003465),
//             Color(0xFF1874CF),
//           ],
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
//       child: Column(
//         children: [
//           Container(
//             width: 75,
//             height: 77,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('lib/images/Trusticon.png'),
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Reserve Assistive Equipment',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'Inter',
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               letterSpacing: -0.2,
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Browse available items and request a rental',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xFFEAF2FA),
//               fontFamily: 'Inter',
//               fontSize: 15,
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAvailableEquipmentSection() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(11),
//         color: Colors.white,
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Available Equipment',
//             style: TextStyle(
//               color: Color.fromRGBO(212, 133, 18, 1),
//               fontFamily: 'Inter',
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 20),

//           _equipmentItem('lib/images/Electricwheelchair.png', 'Wheelchairs'),
//           const SizedBox(height: 15),
//           _equipmentItem('lib/images/Walker.png', 'Walkers & Crutches'),
//           const SizedBox(height: 15),
//           _equipmentItem('lib/images/Massagetable.png', 'Medical Beds'),
//           const SizedBox(height: 15),
//           _equipmentItem('lib/images/Sphygmomanometer.png', 'Monitors & Medical Devices'),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               Transform.rotate(
//                 angle: 90 * (math.pi / 180),
//                 child: Container(
//                   width: 25,
//                   height: 25,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('lib/images/More.png'),
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 7),
//               const Text(
//                 'And more...',
//                 style: TextStyle(
//                   color: Color.fromRGBO(0, 0, 0, 1),
//                   fontFamily: 'Inter',
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _equipmentItem(String imagePath, String text) {
//     return Row(
//       children: [
//         Container(
//           width: 25,
//           height: 25,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(imagePath),
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//         const SizedBox(width: 7),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.black,
//               fontFamily: 'Inter',
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBrowseButton(BuildContext context) {
//     return Center(
//       child: InkWell(
//         onTap: () {
//           print("Browse Equipment tapped");
//           // Later: push a rental list page here
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(21),
//             gradient: const LinearGradient(
//               colors: [
//                 Color(0xFFFFCC00),
//                 Color(0xFFFFB400),
//               ],
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//           child: const Text(
//             'Browse Equipment',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// class browsePage extends StatelessWidget {
//   const browsePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const SizedBox(height: 20),
//           _buildReserveEquipmentCard(),
//           const SizedBox(height: 38),
//           _buildAvailableEquipmentSection(),
//           const SizedBox(height: 38),
//           _buildBrowseButton(context),
//           const SizedBox(height: 30),
//         ],
//       ),
//     );
//   }

//   Widget _buildReserveEquipmentCard() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x14003465),
//             offset: Offset(0, 6),
//             blurRadius: 16,
//           ),
//         ],
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             Color(0xFF003465),
//             Color(0xFF1874CF),
//           ],
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
//       child: Column(
//         children: [
//           Container(
//             width: 75,
//             height: 77,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('lib/images/Trusticon.png'),
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Text(
//             'Reserve Assistive Equipment',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'Inter',
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               letterSpacing: -0.2,
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'Browse available items and request a rental',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               color: Color(0xFFEAF2FA),
//               fontFamily: 'Inter',
//               fontSize: 15,
//               height: 1.5,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAvailableEquipmentSection() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(11),
//         color: Colors.white,
//       ),
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Available Equipment',
//             style: TextStyle(
//               color: Color.fromRGBO(212, 133, 18, 1),
//               fontFamily: 'Inter',
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 20),

//           _equipmentItem('lib/images/Electricwheelchair.png', 'Wheelchairs'),
//           const SizedBox(height: 15),
//           _equipmentItem('lib/images/Walker.png', 'Walkers & Crutches'),
//           const SizedBox(height: 15),
//           _equipmentItem('lib/images/Massagetable.png', 'Medical Beds'),
//           const SizedBox(height: 15),
//           _equipmentItem('lib/images/Sphygmomanometer.png', 'Monitors & Medical Devices'),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               Transform.rotate(
//                 angle: 90 * (math.pi / 180),
//                 child: Container(
//                   width: 25,
//                   height: 25,
//                   decoration: const BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('lib/images/More.png'),
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 7),
//               const Text(
//                 'And more...',
//                 style: TextStyle(
//                   color: Color.fromRGBO(0, 0, 0, 1),
//                   fontFamily: 'Inter',
//                   fontSize: 14,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _equipmentItem(String imagePath, String text) {
//     return Row(
//       children: [
//         Container(
//           width: 25,
//           height: 25,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(imagePath),
//               fit: BoxFit.contain,
//             ),
//           ),
//         ),
//         const SizedBox(width: 7),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.black,
//               fontFamily: 'Inter',
//               fontSize: 14,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildBrowseButton(BuildContext context) {
//     return Center(
//       child: InkWell(
//         onTap: () {
//           print("Browse Equipment tapped");
//           // Later: push a rental list page here
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(21),
//             gradient: const LinearGradient(
//               colors: [
//                 Color(0xFFFFCC00),
//                 Color(0xFFFFB400),
//               ],
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//           child: const Text(
//             'Browse Equipment',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

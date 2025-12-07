import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project444/signup.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Reservation/reservation.dart';
import 'Donation/donor_page.dart';
import 'inventory/inventory_admin.dart';
import 'login.dart';
import 'signup.dart';
import 'admin_dashboard.dart';
import 'inventory_list_screen.dart';
import 'reservation/reservation_dates_screen.dart';
import 'reservation/reservation_confirm_screen.dart';
import 'reservation/reservation_success_screen.dart';
import 'reservation/reservation_tracking_screen.dart';
import 'profilePage.dart';

final ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
final _AppColors appColors = const _AppColors();

class _AppColors extends ThemeExtension<_AppColors> {
  final Color? brand;
  const _AppColors({this.brand});

  @override
  _AppColors copyWith({Color? brand}) {
    return _AppColors(brand: brand ?? this.brand);
  }

  @override
  _AppColors lerp(ThemeExtension<_AppColors>? other, double t) {
    if (other is! _AppColors) return this;
    return _AppColors(brand: Color.lerp(brand, other.brand, t));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    try {
      await Firebase.initializeApp();
    } catch (_) {}
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care Center',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        extensions: <ThemeExtension<dynamic>>[appColors],
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (c) => const MyHomePage(),
        '/donor': (c) => const DonorPage(),
        '/admin': (c) => const AdminPage(userName: ''),
        '/login': (c) => const LoginPage(),
        '/signup': (c) => const SignupPage(),
        "/inventory": (c) => const InventoryListScreen(),
        // "/dates": (c) => const ReservationDatesScreen(),
        "/confirm": (c) => const Placeholder(),
        "/success": (c) => const ReservationSuccessScreen(),
        "/tracking": (c) => const ReservationTrackingScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? userName;

  const MyHomePage({super.key, this.userName});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  Widget _lockedFeature(String title, IconData icon) {
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
              onTap: () => Navigator.pushNamed(context, '/login'),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 44,
                      color: const Color(0xFF003465),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF003465),
                        height: 1.1,
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Care Center'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupPage()),
              );
            },
            child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
DrawerHeader(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primary,
  ),
  child: FirebaseAuth.instance.currentUser == null
      ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage:
                  AssetImage('lib/images/ellipse5.svg'),
            ),
            SizedBox(height: 10),
            Text(
              "Welcome, Guest!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        )
      : FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NewinventoryWidget()),
                );
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
      body: Container(
        color: const Color(0xFFF7FBFF),
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to Care Center Management App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF003465),
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Login to access all features',
                      style: TextStyle(
                        color: Color(0xFFAAA6B2),
                        fontSize: 16,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 48),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _lockedFeature('Inventory', Icons.inventory_2),
                        _lockedFeature('Reservation', Icons.calendar_month),
                        _lockedFeature('Donations', Icons.volunteer_activism),
                        _lockedFeature('Tracking', Icons.bar_chart),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminPage extends StatelessWidget {
  final String userName;
  const AdminPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return const AdminDashboard();
  }
}
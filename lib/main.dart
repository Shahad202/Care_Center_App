import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project444/signup.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'reports.dart';
import 'reservation/reservation.dart';
import 'Donation/donor_page.dart';
import 'inventory/inventory_admin.dart';
import 'inventory/inventory_guest.dart';
import 'login.dart';
import 'signup.dart';
import 'admin_dashboard.dart';
import 'inventory_list_screen.dart';
import 'reservation/reservation_dates_screen.dart';
import 'reservation/reservation_confirm_screen.dart';
import 'reservation/reservation_success_screen.dart' as success_screen;
import 'Reservation/reservation_tabs.dart';
import 'profilePage.dart';
import 'package:project444/rental_history_button.dart';
import 'package:project444/common_drawer.dart';
import 'package:project444/rental_history_view.dart';

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
        "/inventory": (c) => InventoryGuest(),
        "/inventory_admin": (c) => NewinventoryWidget(),
        "/renter": (c) => const RenterPage(),
        "/reports": (c) => const CareCenter(),
        //"/dates": (c) => const ReservationDatesScreen(inventoryItemId: '', itemName: '', requestedQuantity: 8,),
        "/confirm": (c) => const Placeholder(),
        "/success": (c) => const success_screen.ReservationSuccessScreen(),
        "/tracking": (c) => const TrackingPage(),
        "/tracking_user": (c) => const RentalHistoryButton(),
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
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final role = (snap.data()?['role'] ?? 'user').toString();
      if (mounted) setState(() => _userRole = role);
    } catch (_) {}
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 44, color: const Color(0xFF003465)),
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFF003465),
          elevation: 0,
          toolbarHeight: 70,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 24),
              tooltip: 'Open menu',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupPage()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: RentalHistoryButton(),
            ),
          ],
        ),
      ),
      drawer: CommonDrawer(
        userRole: _userRole,
        onRoleUpdated: () {
          setState(() {
            _loadUserRole();
          });
        },
      ),
      body: Container(
        color: const Color(0xFFF7FBFF),
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

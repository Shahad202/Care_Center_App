import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project444/signup.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'reservation.dart';
import 'Donation/donor_page.dart';
import 'services/hive_service.dart';
import 'login.dart';
import 'signup.dart';
import 'admin_dashboard.dart';
import 'inventory_list_screen.dart';
import 'reservation_dates_screen.dart';
import 'reservation_confirm_screen.dart';
import 'reservation_success_screen.dart';
import 'reservation_tracking_screen.dart';
import 'profilePage.dart';

// Define a color scheme using a seed color

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

// firebse initilizaton takes time to connect to firebase services that is why it is async
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await HiveService.init();
  
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
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        // put your named colors into ThemeData via ThemeExtension
        extensions: <ThemeExtension<dynamic>>[appColors],
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
        ),
        // customize elevated button theme
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
        // customize input decoration theme
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
        '/admin': (c) => const AdminPage(userName: '',),
        '/login': (c) => const LoginPage(),
        '/signup': (c) => const SignupPage(),
        "/inventory": (c) => const InventoryListScreen(),
        "/dates": (c) => const ReservationDatesScreen(),
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
  @override
  Widget _lockedFeature(String title, IconData icon) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/login');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

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

            var data = snapshot.data!.data() as Map<String, dynamic>;
            String name = data["name"] ?? "User";
            String? imageUrl = data["profileImage"];

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : AssetImage('lib/images/default_profile.png')
                          as ImageProvider,
                ),
                SizedBox(height: 10),
                Text(
                  "Welcome, $name!",
                  style: TextStyle(
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
                Navigator.pop(context); // يغلق القائمة
                Navigator.pushNamed(context, '/inventory'); // يروح لصفحتك
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
          ],
        ),
      ),
    
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Care Center Management App!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            Center(
              child: Text(
                'Please login to access the below features.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),

            // tiles that show Features
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _lockedFeature('Inventory', Icons.inventory_2),
                  _lockedFeature('Reservation', Icons.calendar_month),
                  _lockedFeature('Donations', Icons.volunteer_activism),
                  _lockedFeature('Tracking', Icons.bar_chart),
                ],
              ),
            ),
          ],
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
    return const Placeholder();
  }
}
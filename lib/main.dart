import 'package:flutter/material.dart';
import 'package:project444/signup.dart';
import 'login.dart';
import 'donation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

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
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
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
      // home: const MyHomePage(),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Management')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Center(
                child: Text(
                  'App Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text(
                'Authentication & Role Management',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.pop(context);
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
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism),
              title: const Text(
                'Donation Management',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonationPage()),
                );
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
      body: Center(
        child: Text(
          'Welcome to Campus Events Management App!',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project444/Reservation/reservation.dart';

class ReservationSuccessScreen extends StatefulWidget {
  const ReservationSuccessScreen({super.key});

  @override
  State<ReservationSuccessScreen> createState() =>
      _ReservationSuccessScreenState();
}

class _ReservationSuccessScreenState extends State<ReservationSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _sizeAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A66C2),
        title: const Text(
          "Reservation Successful",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _sizeAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _sizeAnimation.value,
                  child: child,
                );
              },
              child: Image.asset("lib/images/success.png", height: 160),
            ),
            const SizedBox(height: 30),
            const Text(
              "Your reservation has been confirmed!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "You can now track the status of your reservation.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/tracking");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A66C2),
                ),
                child: const Text("View Tracking"),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const RenterPage()),
                  (route) => false,
                );
              },
              child: const Text(
                "Back to Inventory",
                style: TextStyle(color: Color(0xFF0A66C2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

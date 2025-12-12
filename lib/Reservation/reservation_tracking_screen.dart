import 'package:flutter/material.dart';
import 'package:project444/Reservation/reservation.dart';



class ReservationSuccessScreen extends StatefulWidget {
  const ReservationSuccessScreen({super.key});

  @override
  State<ReservationSuccessScreen> createState() => _ReservationSuccessScreenState();
}

class _ReservationSuccessScreenState extends State<ReservationSuccessScreen> with SingleTickerProviderStateMixin{
 
 late AnimationController _controller;
  late Animation<double> _sizeAnimation;
 
 
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _sizeAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut)
    );
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
        body: Padding(padding:  const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Implement the tracking screen UI here, or restore the correct widget.
            Center(child: Text('Reservation Tracking Screen (implement UI here)')),
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A66C2),
                ),
                child: const Text("View Tracking"),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: (){
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
             )
          ],
        ),
        )
    );
  }
}
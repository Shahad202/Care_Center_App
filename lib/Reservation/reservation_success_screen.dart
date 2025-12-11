import 'package:flutter/material.dart';

class ReservationSuccessScreen extends StatelessWidget {
  const ReservationSuccessScreen({super.key});

  @override
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
            // صورة نجاح — نزّلي أي صورة نجاح وخلي اسمها:
            // success.png داخل assets/images/
            Image.asset("lib/images/success.png", height: 160),

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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/tabs', // your tabs page route
                  (route) =>
                      false, // removes all previous routes so the tabs page becomes root
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

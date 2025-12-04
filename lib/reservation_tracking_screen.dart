import 'package:flutter/material.dart';

class ReservationTrackingScreen extends StatelessWidget {
  const ReservationTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A66C2),
        title: const Text(
          "Reservation Tracking",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reservation Status",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            _statusStep(
              title: "Request Sent",
              subtitle: "Your reservation request has been created.",
              isDone: true,
            ),

            _statusStep(
              title: "Pending Approval",
              subtitle: "Waiting for the admin to review your request.",
              isDone: false,
            ),

            _statusStep(
              title: "Approved",
              subtitle: "Your reservation will start soon.",
              isDone: false,
            ),

            _statusStep(
              title: "Ready for Pickup",
              subtitle: "Your equipment is available now.",
              isDone: false,
            ),

            _statusStep(
              title: "Returned",
              subtitle: "Reservation completed successfully.",
              isDone: false,
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName("/inventory"),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A66C2),
                ),
                child: const Text("Back to Inventory"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تصميم كل خطوة
  Widget _statusStep({
    required String title,
    required String subtitle,
    required bool isDone,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDone ? const Color(0xFF0A66C2) : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 2),
            blurRadius: 5,
          ),
        ],
      ),

      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? const Color(0xFF0A66C2) : Colors.grey,
            size: 28,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDone ? const Color(0xFF0A66C2) : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

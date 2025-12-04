import 'package:flutter/material.dart';

class ReservationConfirmScreen extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String itemName;

  const ReservationConfirmScreen({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm Reservation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A66C2),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailBox(title: "Equipment", value: itemName),
            const SizedBox(height: 16),

            _detailBox(
              title: "Start Date",
              value: "${startDate.day}/${startDate.month}/${startDate.year}",
            ),
            const SizedBox(height: 16),

            _detailBox(
              title: "End Date",
              value: "${endDate.day}/${endDate.month}/${endDate.year}",
            ),
            const SizedBox(height: 32),

            const Text(
              "Notes (optional)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Add any notes here...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/success");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A66C2),
                ),
                child: const Text("Confirm Reservation"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailBox({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

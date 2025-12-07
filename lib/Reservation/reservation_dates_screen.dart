import 'package:flutter/material.dart';
import 'package:project444/reservation/reservation_confirm_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project444/login.dart';
import 'package:project444/profilePage.dart';
import 'package:project444/reservation/reservation_confirm_screen.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reservation_success_screen.dart';

class ReservationDatesScreen extends StatefulWidget {
  final String inventoryItemId;
  final String itemName;
  final int requestedQuantity;

  const ReservationDatesScreen({
    super.key,
    required this.inventoryItemId,
    required this.itemName,
    required this.requestedQuantity,
  });

  @override
  State<ReservationDatesScreen> createState() => _ReservationDatesScreenState();
}

class _ReservationDatesScreenState extends State<ReservationDatesScreen> {
  DateTime? startDate;
  DateTime? endDate;
  bool _loading = false;

  Future<void> pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 3),
    );

    if (selected != null) {
      setState(() {
        if (isStart) {
          startDate = selected;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = selected;
        }
      });
    }
  }

  Future<void> _confirmReservation() async {
    if (startDate == null || endDate == null) return;

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final inventoryRef = FirebaseFirestore.instance
          .collection('inventory')
          .doc(widget.inventoryItemId);

      final inventorySnap = await inventoryRef.get();
      final availableQuantity = inventorySnap['quantity'] ?? 0;

      if (widget.requestedQuantity > availableQuantity) {
        throw Exception(
            'Requested quantity exceeds available quantity ($availableQuantity)');
      }

      // 1. Add reservation
      await FirebaseFirestore.instance.collection('reservations').add({
        'userId': user.uid,
        'inventoryItemId': widget.inventoryItemId,
        'itemName': widget.itemName,
        'quantity': widget.requestedQuantity,
        'startDate': Timestamp.fromDate(startDate!),
        'endDate': Timestamp.fromDate(endDate!),
        'status': 'pending',
        'createdAt': Timestamp.now(),
      });

      // 2. Update inventory quantity
      await inventoryRef.update({
        'quantity': FieldValue.increment(-widget.requestedQuantity),
      });

      // 3. Navigate to success
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ReservationSuccessScreen()),
      );
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Reservation failed: $e')));
    }
  }

  Widget _dateBox({required String label, DateTime? date, bool isStart = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => pickDate(isStart: isStart),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
              children: [
                const Icon(Icons.calendar_today, color: Color(0xFF0A66C2)),
                const SizedBox(width: 12),
                Text(
                  date == null
                      ? 'Select date'
                      : '${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation'),
        backgroundColor: const Color(0xFF0A66C2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item: ${widget.itemName}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text('Quantity: ${widget.requestedQuantity}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            _dateBox(label: 'Start Date', date: startDate, isStart: true),
            const SizedBox(height: 16),
            _dateBox(label: 'End Date', date: endDate, isStart: false),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_loading || startDate == null || endDate == null)
                    ? null
                    : _confirmReservation,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A66C2)),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirm Reservation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

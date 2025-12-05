import 'package:flutter/material.dart';
import 'reservation_confirm_screen.dart';

class ReservationDatesScreen extends StatefulWidget {
  const ReservationDatesScreen({super.key});

  @override
  State<ReservationDatesScreen> createState() => _ReservationDatesScreenState();
}

class _ReservationDatesScreenState extends State<ReservationDatesScreen> {
  DateTime? startDate;
  DateTime? endDate;

  // دالة لفتح DatePicker
  Future<void> pickDate({required bool isStart}) async {
    DateTime now = DateTime.now();

    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 3),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0A66C2), // أزرق
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select Reservation Dates",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A66C2),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Start Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            InkWell(
              onTap: () => pickDate(isStart: true),
              child: _dateBox(
                text: startDate == null
                    ? "Choose start date"
                    : "${startDate!.day}/${startDate!.month}/${startDate!.year}",
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "End Date",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            InkWell(
              onTap: startDate == null ? null : () => pickDate(isStart: false),
              child: _dateBox(
                text: endDate == null
                    ? "Choose end date"
                    : "${endDate!.day}/${endDate!.month}/${endDate!.year}",
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (startDate != null && endDate != null)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReservationConfirmScreen(
                              startDate: startDate!,
                              endDate: endDate!,
                              itemName:
                                  "Wheelchair", // <<< لاحقاً نرسل اسم الجهاز الحقيقي
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A66C2),
                ),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // صندوق التاريخ
  Widget _dateBox({required String text}) {
    return Container(
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
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

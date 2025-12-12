import 'package:flutter/material.dart';
import 'package:project444/rental_history_view.dart';

/// Reusable Rental History Icon Button for app bars
/// Shows user-specific rental history when showUserOnly=true
/// Shows all rentals when showUserOnly=false
class RentalHistoryButton extends StatelessWidget {
  final bool showUserOnly;

  const RentalHistoryButton({
    Key? key,
    this.showUserOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RentalHistoryView(showUserOnly: showUserOnly),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.history,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

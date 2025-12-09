import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DonationDetailsPage extends StatefulWidget {
  final Map<String, dynamic> donation;
  const DonationDetailsPage({super.key, required this.donation});

  @override
  State<DonationDetailsPage> createState() => _DonationDetailsPageState();
}

class _DonationDetailsPageState extends State<DonationDetailsPage> {
  
  // Condition Color
  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'new':
      case 'like new':
        return const Color(0xFF4CAF50);
      case 'good':
        return const Color(0xFF76C893);
      case 'fair':
        return const Color(0xFFFFA726);
      case 'needs repair':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF4CAF50);
    }
  }
  
  // Status Color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFA726);
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'rejected':
        return const Color(0xFFF44336);
      case 'in review':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFFAAA6B2);
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      if (date is Timestamp) {
        final dt = date.toDate();
        return '${dt.day} ${_getMonthName(dt.month)} ${dt.year}'; // e.g., "7 Dec 2025"
      }
      if (date is DateTime) {
        return '${date.day} ${_getMonthName(date.month)} ${date.year}';
      }
      final parsed = DateTime.tryParse(date.toString());
      if (parsed != null) {
        return '${parsed.day} ${_getMonthName(parsed.month)} ${parsed.year}';
      }
      return date.toString();
    } catch (_) {
      return 'N/A';
    }
  }

  String _getMonthName(int month) => const [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][month - 1];

  IconData _mapIcon(String key) {
    switch (key) {
      case 'wheelchair':
        return Icons.wheelchair_pickup;
      case 'walker':
        return Icons.elderly;
      case 'crutches':
        return Icons.accessibility;
      case 'shower_chair':
        return Icons.chair;
      case 'hospital_bed':
        return Icons.bed;
      case 'other':
        return Icons.volunteer_activism;
      default:
        return Icons.inventory_2_outlined;
    }
  }

  Widget _iconTile(String iconKey) {
    return Container(
      decoration: BoxDecoration(
        // Subtle gradient background
        gradient: LinearGradient(
          colors: [
            const Color(0xFF003465).withOpacity(0.1),  // Dark blue 10%
            const Color(0xFF1976D2).withOpacity(0.05), // Medium blue 5%
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Icon(
          _mapIcon(iconKey),  // Maps to appropriate icon (wheelchair, walker, etc.)
          color: const Color(0xFF003465),
          size: 96,  // Large icon
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // STEP 1: Extract key data from the donation Map
    final iconKey = (widget.donation['iconKey'] ?? 'default').toString();
    final statusColor = _getStatusColor(widget.donation['status'] ?? 'pending');
    final conditionColor = _getConditionColor(widget.donation['condition'] ?? 'good');

    // STEP 2: Return Scaffold with AppBar
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),  // Light blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF003465),  // Dark blue header
        title: const Text('Donation Details'),
      ),
      
      // STEP 3: Build scrollable body (for long descriptions)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STEP 4: Large icon display (240px height)
            SizedBox(height: 240, child: _iconTile(iconKey)),
            const SizedBox(height: 20),
            
            // STEP 5: Item name + Status badge
            Row(
              children: [
                // Item name (left side)
                Expanded(
                  child: Text(
                    widget.donation['itemName'] ?? 'Unknown Item',  // e.g., "Wheelchair"
                    style: const TextStyle(
                      color: Color(0xFF003465),
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                ),
                
                // Status badge (right side)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),  // Status color with 12% opacity
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: statusColor.withOpacity(0.6), width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: statusColor, size: 10),  // Status dot
                      const SizedBox(width: 6),
                      Text(
                        _getStatusText(widget.donation['status'] ?? 'pending'),
                        style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // STEP 6: Details section
            _sectionTitle('Details'),
            const SizedBox(height: 12),
            _detailCard([
              // Condition row
              _detailRow(
                Icons.verified,
                'Condition',
                widget.donation['condition'] ?? 'N/A',
                _getConditionColor(widget.donation['condition'] ?? 'good'),
              ),
              // Quantity row
              _detailRow(
                Icons.numbers,
                'Quantity',
                widget.donation['quantity']?.toString() ?? 'N/A',
              ),
              // Location row
              _detailRow(
                Icons.location_on_outlined,
                'Location',
                widget.donation['location'] ?? 'N/A',
              ),
              // Created date row
              _detailRow(
                Icons.calendar_today_outlined,
                'Created',
                _formatDate(widget.donation['createdAt']),
              ),
            ]),
            
            // STEP 7: Description section (only if description exists)
            if (widget.donation['description'] != null &&
                widget.donation['description'].toString().isNotEmpty) ...[
              const SizedBox(height: 24),
              _sectionTitle('Description'),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 80),  // Minimum 80px height
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE6E8EB), width: 1),
                ),
                child: Text(
                  widget.donation['description'],  // User-provided description text
                  style: const TextStyle(
                    color: Color(0xFF424242),
                    fontSize: 15,
                    height: 1.6,  // Better line spacing
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
            
            const SizedBox(height: 30),  // Bottom spacing
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          color: Color(0xFF003465),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      );

  Widget _detailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003465).withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: children.expand((w) => [w, const SizedBox(height: 12)]).toList()..removeLast(),
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    String label,
    dynamic value, [
    Color? highlightColor,
  ]) {
    if (value == null) return const SizedBox.shrink();
    
    return Row(
      children: [
        // Icon box on left
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (highlightColor ?? const Color(0xFF003465)).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: highlightColor ?? const Color(0xFF003465),
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        
        // Label + Value on right
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,  // "Condition", "Quantity", etc.
                style: const TextStyle(
                  color: Color(0xFFAAA6B2),  // Gray label
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.toString(),  // Actual value
                style: TextStyle(
                  color: highlightColor ?? const Color(0xFF003465),  // Colored text
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
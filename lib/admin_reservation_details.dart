import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminReservationDetails extends StatefulWidget {
  final String reservationId;
  final Map<String, dynamic> reservationData;

  const AdminReservationDetails({
    required this.reservationId,
    required this.reservationData,
  });

  @override
  State<AdminReservationDetails> createState() => _AdminReservationDetailsState();
}

class _AdminReservationDetailsState extends State<AdminReservationDetails> {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = widget.reservationData['userId'];
      if (userId != null) {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (mounted && userDoc.exists) {
          setState(() {
            _userData = userDoc.data();
          });
        }
      }
    } catch (_) {
      // Keep _userData null if error
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFA726);
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'rejected':
        return const Color(0xFFF44336);
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
        return '${dt.day} ${_getMonthName(dt.month)} ${dt.year}';
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

  Widget _iconTile() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF003465).withOpacity(0.1),
            const Color(0xFF1976D2).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Center(
        child: Icon(Icons.calendar_month, color: Color(0xFF003465), size: 96),
      ),
    );
  }

  Future<void> _approveReservation() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // Update reservation status to 'approved'
      await _firestore.collection('reservations').doc(widget.reservationId).update({
        'status': 'approved',
        'approvedAt': Timestamp.now(),
      });

      // TODO: Update inventory to reduce available quantity if needed
      // This depends on your inventory structure

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservation approved successfully!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );

      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) Navigator.pop(context, 'approved');
      });

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _rejectReservation() async {
    if (_isLoading) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reject Reservation',
          style: TextStyle(color: Color(0xFF003465), fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to reject this reservation?',
          style: TextStyle(color: Color(0xFF666666), fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF003465))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    
    setState(() => _isLoading = true);

    try {
      await _firestore.collection('reservations').doc(widget.reservationId).update({
        'status': 'rejected',
        'rejectedAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservation rejected'),
          backgroundColor: Color(0xFFFFA726),
        ),
      );

      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) Navigator.pop(context, 'rejected');
      });

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.reservationData;
    final status = data['status'] ?? 'pending';
    final statusColor = _getStatusColor(status);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003465),
        elevation: 0,
        title: const Text('Reservation Details'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20).copyWith(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 240, child: _iconTile()),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data['itemName'] ?? 'Unknown Equipment',
                        style: const TextStyle(
                          color: Color(0xFF003465),
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: statusColor.withOpacity(0.6), width: 1.5),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, color: statusColor, size: 10),
                          const SizedBox(width: 6),
                          Text(
                            _getStatusText(status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _sectionTitle('Reservation Details'),
                const SizedBox(height: 12),
                _detailCard([
                  _detailRow(
                    Icons.numbers,
                    'Quantity',
                    '${data['quantity'] ?? 0}',
                  ),
                  _detailRow(
                    Icons.calendar_today_outlined,
                    'Created',
                    _formatDate(data['createdAt']),
                  ),
                ]),

                if (_userData != null) ...[
                  const SizedBox(height: 24),
                  _sectionTitle('User Information'),
                  const SizedBox(height: 12),
                  _detailCard([
                    _detailRow(
                      Icons.person,
                      'Name',
                      _userData!['name'] ?? 'N/A',
                    ),
                    _detailRow(
                      Icons.email,
                      'Email',
                      _userData!['email'] ?? 'N/A',
                    ),
                    if (_userData!['phone'] != null)
                      _detailRow(
                        Icons.phone,
                        'Phone',
                        _userData!['phone'],
                      ),
                  ]),
                ],

                if (data['notes'] != null &&
                    data['notes'].toString().isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _sectionTitle('Notes'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 80),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6E8EB), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF003465).withOpacity(0.05),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Text(
                      data['notes'],
                      style: const TextStyle(
                        color: Color(0xFF424242),
                        fontSize: 15,
                        height: 1.6,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (status == 'pending')
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF44336),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isLoading ? null : _rejectReservation,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.close, size: 20),
                        label: Text(
                          _isLoading ? '' : 'Reject',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _isLoading ? null : _approveReservation,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Icon(Icons.check, size: 20),
                        label: Text(
                          _isLoading ? '' : 'Approve',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
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
    String value, [
    Color? highlightColor,
  ]) {
    return Row(
      children: [
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFAAA6B2),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  color: highlightColor ?? const Color(0xFF003465),
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
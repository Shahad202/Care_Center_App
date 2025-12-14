import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_reservation_details.dart';
import 'admin_reservation_details.dart';
import 'admin_dashboard.dart';

class AdminPendingReservations extends StatefulWidget {
  const AdminPendingReservations({super.key});

  @override
  State<AdminPendingReservations> createState() => _AdminPendingReservationsState();
}

class _AdminPendingReservationsState extends State<AdminPendingReservations> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final Set<String> _handledReservationIds = {};  // Track handled IDs

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() {
    if (_auth.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  Stream<QuerySnapshot> getAllReservations() {
    if (_auth.currentUser == null) return const Stream.empty();
    
    try {
      return _firestore
          .collection('reservations')
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (_) {
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF),
      appBar: AppBar(
        title: const Text('Pending Reservations'),
        backgroundColor: const Color(0xFF003465),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAllReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF003465)),
              ),
            );
          }

          if (snapshot.hasError) {
            return _errorState(snapshot.error.toString());
          }

          final docs = snapshot.data?.docs ?? [];
          final filteredDocs = docs
              .where((d) => !_handledReservationIds.contains(d.id))
              .toList();

          if (filteredDocs.isEmpty) return _emptyState();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final data = filteredDocs[index].data() as Map<String, dynamic>;

                  final equipmentName = data['itemName'] ?? 'Unknown Equipment';
                  final quantity = data['quantity'] ?? 0;
                  final status = (data['status'] ?? 'pending').toString().toLowerCase();
                  final createdAt = data['createdAt'] as Timestamp?;

                  String formattedDate = 'N/A';
                  if (createdAt != null) {
                    final date = createdAt.toDate();
                    formattedDate = '${date.day} ${_getMonthName(date.month)} ${date.year}';
                  }

                  final statusColor = _getStatusColor(status);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE6E8EB), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF003465).withOpacity(0.06),
                          offset: const Offset(0, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Hero(
                                tag: 'admin_reservation_${filteredDocs[index].id}',
                                child: _iconTile(),
                              ),
                              const SizedBox(width: 12),
                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      equipmentName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Color(0xFF003465),
                                        letterSpacing: -0.1,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    
                                    Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        color: Color(0xFF7A869A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    Row(
                                      children: [
                                        Flexible(
                                          child: _infoChip(Icons.numbers, 'Qty: $quantity', const Color(0xFF7B1FA2)),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: statusColor.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(999),
                                              border: Border.all(color: statusColor.withOpacity(0.32), width: 1),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 6,
                                                  height: 6,
                                                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                                                ),
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    _getStatusText(status),
                                                    style: TextStyle(
                                                      color: statusColor,
                                                      fontSize: 11.5,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003465),
                                minimumSize: const Size(double.infinity, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  slideUpRoute(
                                    AdminReservationDetails(
                                      reservationId: filteredDocs[index].id,
                                      reservationData: data,
                                    ),
                                  ),
                                );

                                if (result == 'approved' || result == 'rejected') {
                                  setState(() {
                                    _handledReservationIds.add(filteredDocs[index].id);
                                  });
                                }
                              },
                              child: const Text(
                                'View',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconTile() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF003465).withOpacity(0.1),
            const Color(0xFF1976D2).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E8EB), width: 1),
      ),
      child: const Center(
        child: Icon(Icons.calendar_month, color: Color(0xFF003465), size: 32),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.inbox_outlined, size: 70, color: Color(0xFFAAA6B2)),
          SizedBox(height: 16),
          Text(
            'No pending reservations',
            style: TextStyle(
              color: Color(0xFF003465),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'New reservations will appear here',
            style: TextStyle(color: Color(0xFFAAA6B2), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _errorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 70, color: Color(0xFFF44336)),
          const SizedBox(height: 14),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF003465),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Color(0xFFAAA6B2)),
            ),
          ),
        ],
      ),
    );
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

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

Route slideUpRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
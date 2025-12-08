import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_donation_details.dart';
import 'navigation_transitions.dart';

class AdminPendingDonations extends StatefulWidget {
  const AdminPendingDonations({super.key});

  @override
  State<AdminPendingDonations> createState() => _AdminPendingDonationsState();
}

class _AdminPendingDonationsState extends State<AdminPendingDonations> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final Set<String> _handledDonationIds = {};  // Track handled IDs

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() {
    if (_auth.currentUser == null) {
      // No user logged in - navigate to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  Stream<QuerySnapshot> getAllDonations() {
    // STEP 1: Check if user is authenticated
    if (_auth.currentUser == null) return const Stream.empty();
    
    try {
      // STEP 2: Query Firestore for pending donations
      return _firestore
          .collection('donations')
          .where('status', isEqualTo: 'pending')  // Only pending donations
          .orderBy('createdAt', descending: true)  // Newest first
          .snapshots();  // Real-time stream
      
    } catch (_) {
      // STEP 3: Return empty stream if error
      return const Stream.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    // STEP 1: Auth check - show loading if not authenticated
    if (_auth.currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // STEP 2: Return Scaffold with AppBar
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFF), // Light blue
      appBar: AppBar(
        title: const Text('All Donations'),
        backgroundColor: const Color(0xFF003465), // Dark blue
        elevation: 0,
      ),

      // STEP 3: Real-time StreamBuilder
      body: StreamBuilder<QuerySnapshot>(
        stream: getAllDonations(), // Listen to pending donations
        builder: (context, snapshot) {
          // STEP 4: Handle loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF003465)),
              ),
            );
          }

          // STEP 5: Handle errors
          if (snapshot.hasError) {
            return _errorState(snapshot.error.toString());
          }

          // STEP 6: Get all pending documents
          final docs = snapshot.data?.docs ?? [];

          // STEP 7: Filter out donations admin already handled
          final filteredDocs = docs
              .where((d) => !_handledDonationIds.contains(d.id))  // Filter out handled
              .toList();

          // STEP 8: Show empty state if no pending donations
          if (filteredDocs.isEmpty) return _emptyState();

          // STEP 9: Build list of donation cards
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final data = filteredDocs[index].data() as Map<String, dynamic>;

                  // Extract donation data
                  final itemName = data['itemName'] ?? 'Unknown Item';
                  final quantity = data['quantity'] ?? 0;
                  final status = (data['status'] ?? 'pending').toString().toLowerCase();
                  final createdAt = data['createdAt'] as Timestamp?;
                  final iconKey = (data['iconKey'] ?? 'default').toString();

                  // Format date
                  String formattedDate = 'N/A';
                  if (createdAt != null) {
                    final date = createdAt.toDate();
                    formattedDate = '${date.day} ${_getMonthName(date.month)} ${date.year}';
                  }

                  final statusColor = _getStatusColor(status);

                  // STEP 10: Build donation card
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
                          // ROW 1: Icon + Details (left) + Status (right)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon tile (70x70)
                              Hero(
                                tag: 'admin_donation_${filteredDocs[index].id}',
                                child: _iconTile(iconKey),  // Wheelchair, walker, etc.
                              ),
                              const SizedBox(width: 12),
                              
                              // Details section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Item name (bold, dark blue)
                                    Text(
                                      itemName,  // e.g., "Wheelchair"
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
                                    
                                    // Submission date (gray, small)
                                    Text(
                                      formattedDate,  // e.g., "7 Dec 2025"
                                      style: const TextStyle(
                                        color: Color(0xFF7A869A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Quantity chip + Status badge
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
                          
                          // ROW 2: View button (full width)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003465),  // Dark blue
                                minimumSize: const Size(double.infinity, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              onPressed: () async {
                                // Navigate to AdminDonationDetails
                                final result = await Navigator.push(
                                  context,
                                  slideUpRoute(
                                    AdminDonationDetails(
                                      donationId: filteredDocs[index].id,
                                      donationData: data,
                                    ),
                                  ),
                                );

                                // If approved or rejected, hide this card
                                if (result == 'approved' || result == 'rejected') {
                                  setState(() {
                                    _handledDonationIds.add(filteredDocs[index].id);  // Add ID to set
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

  Widget _iconTile(String iconKey) {
    IconData icon;
    switch (iconKey) {
      case 'wheelchair':
        icon = Icons.wheelchair_pickup;
        break;
      case 'walker':
        icon = Icons.elderly;
        break;
      case 'crutches':
        icon = Icons.accessibility;
        break;
      case 'shower_chair':
        icon = Icons.chair;
        break;
      case 'hospital_bed':
        icon = Icons.bed;
        break;
      case 'other':
        icon = Icons.volunteer_activism;
        break;
      default:
        icon = Icons.inventory_2_outlined;
    }
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
      child: Center(
        child: Icon(icon, color: const Color(0xFF003465), size: 32),
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
            'No donations available',
            style: TextStyle(
              color: Color(0xFF003465),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'New submissions will appear here',
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
              error,  // Shows actual error message
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
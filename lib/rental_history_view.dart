import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Reusable Rental History Page
/// Shows all rentals for admins, only current user's rentals for regular users
class RentalHistoryView extends StatefulWidget {
  final bool showUserOnly; // If true, only show current user's rentals

  const RentalHistoryView({
    Key? key,
    this.showUserOnly = false,
  }) : super(key: key);

  @override
  State<RentalHistoryView> createState() => _RentalHistoryViewState();
}

class _RentalHistoryViewState extends State<RentalHistoryView> {
  String _viewMode = 'all'; // 'all', 'active', 'completed'
  String _searchQuery = '';
  List<RentalHistory> _allRentals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRentalHistory();
  }

  Future<void> _loadRentalHistory() async {
    setState(() => _isLoading = true);

    try {
      final currentUserId = widget.showUserOnly 
          ? FirebaseAuth.instance.currentUser?.uid 
          : null;

      // Try to get reservations with ordering first, fallback if it fails
      QuerySnapshot snapshot;
      try {
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance
            .collection('reservations')
            .orderBy('createdAt', descending: true);

        // Filter by userId if showing only current user's rentals
        if (currentUserId != null) {
          query = query.where('userId', isEqualTo: currentUserId);
        }

        snapshot = await query.get();
        print('✓ Loaded ${snapshot.docs.length} reservations with ordering');
      } catch (e) {
        // If ordering fails, get without ordering
        print('⚠ Failed to order by createdAt: $e');
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('reservations');

        // Filter by userId if showing only current user's rentals
        if (currentUserId != null) {
          query = query.where('userId', isEqualTo: currentUserId);
        }

        snapshot = await query.get();
        print('✓ Loaded ${snapshot.docs.length} reservations without ordering');
      }

      print('Found ${snapshot.docs.length} total reservations');
      List<RentalHistory> rentals = [];
      int idCounter = 1;

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) continue;

        final userId = (data['userId'] ?? data['uid'] ?? data['user_id']) as String?;
        final equipmentName =
            (data['equipmentName'] ?? data['itemName'] ?? 'Equipment').toString();
        final startDate = (data['startDate'] as Timestamp?)?.toDate();
        final endDate = (data['endDate'] as Timestamp?)?.toDate();
        final returnDate = (data['returnDate'] as Timestamp?)?.toDate();
        var status = (data['status'] ?? 'pending').toString().toLowerCase();

        // Get user details - prioritize users collection
        String userName = 'Unknown User';
        String phone = 'N/A';
        String email = 'N/A';

        if (userId != null) {
          try {
            final userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();
            if (userDoc.exists) {
              final userData = userDoc.data()!;
              userName = (userData['name'] ?? userData['fullName'] ?? 'Unknown User').toString();
              phone = (userData['contact'] ?? userData['phone'] ?? userData['contactNumber'] ?? 'N/A')
                  .toString();
              email = (userData['email'] ?? userData['Email'] ?? 'N/A').toString();
            }
          } catch (_) {}
        }

        // Only use reservation-level data as fallback if users collection lookup failed
        if (userName == 'Unknown User') {
          userName = (data['userName'] ?? data['name'] ?? 'Unknown User').toString();
        }
        if (phone == 'N/A') {
          phone = (data['phone'] ?? data['contact'] ?? data['contactNumber'] ?? 'N/A').toString();
        }
        if (email == 'N/A') {
          email = (data['email'] ?? data['Email'] ?? 'N/A').toString();
        }

        // Determine status based on dates
        if (status == 'active' && endDate != null) {
          final now = DateTime.now();
          if (now.isAfter(endDate) && returnDate == null) {
            status = 'overdue';
          }
        } else if (status == 'returned' || returnDate != null) {
          status = 'completed';
        }

        rentals.add(
          RentalHistory(
            id: idCounter++,
            equipment: equipmentName,
            user: userName,
            phone: phone,
            email: email,
            checkoutDate: startDate != null ? _formatDate(startDate) : 'N/A',
            dueDate: endDate != null ? _formatDate(endDate) : 'N/A',
            returnDate: returnDate != null ? _formatDate(returnDate) : null,
            status: status,
            notes: data['notes'] ?? '',
          ),
        );
      }

      if (mounted) {
        setState(() {
          _allRentals = rentals;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading rental history: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _allRentals = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<RentalHistory> get _filteredRentals {
    List<RentalHistory> filtered = _allRentals;

    // Filter by view mode
    if (_viewMode == 'active') {
      filtered = filtered.where((r) => r.status != 'completed').toList();
    } else if (_viewMode == 'completed') {
      filtered = filtered.where((r) => r.status == 'completed').toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((r) {
        return r.user.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            r.equipment.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            r.phone.contains(_searchQuery);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0A66C2),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        const SizedBox(height: 16),
                        _buildViewModeSelector(),
                        const SizedBox(height: 16),
                        _buildStats(),
                        const SizedBox(height: 16),
                        ..._filteredRentals
                            .map((rental) => _buildRentalCard(rental))
                            .toList(),
                        if (_filteredRentals.isEmpty) _buildEmptyState(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final title = widget.showUserOnly ? 'My Rental History' : 'Rental History';
    final subtitle = widget.showUserOnly
        ? 'View your rentals and history'
        : 'View all rentals and history';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo[600]!, Colors.indigo[700]!],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFc7d2fe),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search by name, equipment, or phone...',
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey[400]),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildViewModeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildViewModeButton('all', 'All Rentals')),
          Expanded(child: _buildViewModeButton('active', 'Active')),
          Expanded(child: _buildViewModeButton('completed', 'Completed')),
        ],
      ),
    );
  }

  Widget _buildViewModeButton(String mode, String label) {
    final isActive = _viewMode == mode;
    return InkWell(
      onTap: () => setState(() => _viewMode = mode),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.indigo[600] : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    int activeCount = _allRentals.where((r) => r.status != 'completed').length;
    int completedCount = _allRentals.where((r) => r.status == 'completed').length;
    int overdueCount = _allRentals.where((r) => r.status == 'overdue').length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Active', '$activeCount', Colors.blue),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          Expanded(
            child: _buildStatItem('Completed', '$completedCount', Colors.green),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          Expanded(
            child: _buildStatItem('Overdue', '$overdueCount', Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildRentalCard(RentalHistory rental) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(rental.status).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rental.equipment,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rental.user,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(rental.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(rental.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(rental.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.phone, rental.phone),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.email, rental.email),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Checkout', rental.checkoutDate),
                const SizedBox(height: 8),
                _buildDetailRow('Due Date', rental.dueDate),
                if (rental.returnDate != null) ...[
                  const SizedBox(height: 8),
                  _buildDetailRow('Returned', rental.returnDate!),
                ],
              ],
            ),
          ),
          if (rental.notes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[600],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rental.notes,
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          const Text(
            'No Rentals Found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'overdue':
        return Colors.red;
      case 'active':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'overdue':
        return 'Overdue';
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }
}

// Data Model for Rental History
class RentalHistory {
  final int id;
  final String equipment;
  final String user;
  final String phone;
  final String email;
  final String checkoutDate;
  final String dueDate;
  final String? returnDate;
  final String status; // 'active', 'overdue', 'completed'
  final String notes;

  RentalHistory({
    required this.id,
    required this.equipment,
    required this.user,
    required this.phone,
    required this.email,
    required this.checkoutDate,
    required this.dueDate,
    this.returnDate,
    required this.status,
    required this.notes,
  });
}

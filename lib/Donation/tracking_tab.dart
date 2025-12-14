import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'details.dart';

class TrackingTabPage extends StatefulWidget {
  const TrackingTabPage({super.key});

  @override
  State<TrackingTabPage> createState() => _TrackingTabPageState();
}

class _TrackingTabPageState extends State<TrackingTabPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _selectedStatus;
  late ScrollController _scrollController;
  final Map<int, AnimationController> _animationControllers = {};
  int _cardCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Trigger animation for newly visible cards
    for (int i = 0; i < _cardCount; i++) {
      if (!_animationControllers.containsKey(i)) {
        _createAndStartAnimation(i);
      }
    }
  }

  void _createAndStartAnimation(int index) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 650), // Smooth duration
      vsync: this,
    );
    _animationControllers[index] = controller;
    controller.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
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

  /// Validate and ensure quantity is > 0
  int _getValidQuantity(dynamic quantity) {
    if (quantity is int) return quantity > 0 ? quantity : 1;
    if (quantity is String) return (int.tryParse(quantity) ?? 0) > 0 ? int.parse(quantity) : 1;
    return 1;
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

  String _formatCreatedAt(dynamic createdAt) {
    try {
      if (createdAt == null) return '—';
      if (createdAt is Timestamp) {
        final dt = createdAt.toDate();
        return '${dt.day}/${dt.month}/${dt.year}';
      }
      if (createdAt is DateTime) {
        return '${createdAt.day}/${createdAt.month}/${createdAt.year}'; // e.g., "7/12/2025"
      }
      return createdAt.toString();
    } catch (_) {
      return '—';
    }
  }

  @override
  Widget build(BuildContext context) {
    // STEP 1: Get current user ID
    final uid = FirebaseAuth.instance.currentUser?.uid;
    
    // STEP 2: Create Firestore query - ONLY this user's donations
    Query query = FirebaseFirestore.instance.collection('donations');
    if (uid != null) {
      query = query.where('donorId', isEqualTo: uid);  // Filter by donor
    }
    
    // STEP 3: Order by creation date (newest first)
    final stream = query.orderBy('createdAt', descending: true).snapshots();

    // STEP 4: Build UI with StreamBuilder for real-time updates
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // STEP 5: Show login prompt if not authenticated
          if (uid == null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),  // Orange background
                border: Border.all(color: const Color(0xFFFFA726)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFFFFA726)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Please log in to see your donations.'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 5),
          const Text(
            'My Donations',
            style: TextStyle(
              color: Color(0xFF003465),
              fontFamily: 'Inter',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 20),
          if (uid == null)
            Expanded(child: _emptyState())
          else
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: stream,  // Real-time updates from Firestore
                builder: (context, snapshot) {
                  // STEP 1: Handle loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF003465)),
                      ),
                    );
                  }
                  
                  // STEP 2: Handle errors
                  if (snapshot.hasError) {
                    return _errorState(snapshot.error.toString());
                  }
                  
                  // STEP 3: Get all donations from Firestore
                  final docs = snapshot.data?.docs ?? [];
                  if (docs.isEmpty) {
                    return _emptyState();  // "No donations yet"
                  }

                  // STEP 4: Apply search + status filters
                  final filtered = docs.where((d) {
                    final data = d.data() as Map<String, dynamic>;
                    final name =
                        (data['itemName'] ?? '').toString().toLowerCase();
                    final status =
                        (data['status'] ?? '').toString().toLowerCase();

                    // Check if matches search query
                    final matchesSearch = _query.isEmpty
                        ? true
                        : name.contains(_query.toLowerCase()) ||
                            status.contains(_query.toLowerCase());

                    // Check if matches selected status
                    final matchesStatus = _selectedStatus == null
                        ? true
                        : status == _selectedStatus;

                    return matchesSearch && matchesStatus;
                  }).toList();

                  // STEP 5: Show empty state if no results after filtering
                  if (filtered.isEmpty) {
                    return _emptyFiltered();  // "No matching results"
                  }

                  // STEP 6: Build list of donation cards with animations
                  _cardCount = filtered.length;
                  // Ensure animations exist for all visible cards
                  for (int i = 0; i < filtered.length; i++) {
                    if (!_animationControllers.containsKey(i)) {
                      _createAndStartAnimation(i);
                    }
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final doc = filtered[index];
                      final data = doc.data() as Map<String, dynamic>;
                      // Add document ID to the data map
                      final dataWithId = {...data, 'id': doc.id};
                      
                      final animationController = _animationControllers[index];
                      if (animationController == null) {
                        return _donationCard(dataWithId);
                      }

                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1.0), // Start further below for more pronounced effect
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                          child: FadeTransition(
                            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animationController,
                                curve: Curves.easeIn,
                              ),
                            ),
                            child: _donationCard(dataWithId),
                          ),
                        );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003465).withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // SEARCH FIELD
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v.trim()),
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Search donations...',
                hintStyle: const TextStyle(
                  color: Color(0xFFAAA6B2),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon:
                    const Icon(Icons.search, color: Color(0xFF003465), size: 22),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide:
                      const BorderSide(color: Color(0xFFE0E0E0), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide:
                      const BorderSide(color: Color(0xFF003465), width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // FILTER BUTTON (Status filter)
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF003465), Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003465).withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(26),
                onTap: () async {
                  // Show modal bottom sheet with status options
                  final chosen = await showModalBottomSheet<String?>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) {
                      final statuses = [
                        'pending',
                        'approved',
                        'rejected',
                      ];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Filter by Status',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF003465),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ChoiceChip(
                                  label: const Text('All'),
                                  selected: _selectedStatus == null,
                                  onSelected: (_) => Navigator.pop(context, null),
                                ),
                                ...statuses.map(
                                  (s) => ChoiceChip(
                                    label: Text(s),
                                    selected: _selectedStatus == s,
                                    onSelected: (_) => Navigator.pop(context, s),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    },
                  );
                  if (mounted) setState(() => _selectedStatus = chosen);
                },
                child: const Icon(Icons.tune, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _donationCard(Map<String, dynamic> data) {
    final statusColor = _getStatusColor(data['status'] ?? 'pending');
    final iconKey = (data['iconKey'] ?? 'default').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003465).withOpacity(0.08),
            offset: const Offset(0, 2),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to DonationDetailsPage when tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DonationDetailsPage(donation: data)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // ICON SECTION (88x88)
                Hero(
                  tag: 'donation_${data['itemName']}_${data.hashCode}',
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE6E8EB), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF003465).withOpacity(0.06),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: _iconTile(iconKey),  // Shows wheelchair, walker, etc.
                  ),
                ),
                const SizedBox(width: 12),
                
                // CONTENT SECTION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item name + Date
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data['itemName'] ?? 'Unknown',  // e.g., "Wheelchair"
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF003465),
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatCreatedAt(data['createdAt']),  // e.g., "7/12/2025"
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF7A869A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      
                      // Condition + Quantity chips
                      Row(
                        children: [
                          _infoChip(
                            Icons.inventory_2_outlined,
                            data['condition'] ?? 'N/A',  // e.g., "Good"
                            const Color(0xFF1976D2),
                          ),
                          const SizedBox(width: 8),
                          _infoChip(
                            Icons.numbers,
                            '${data['quantity'] ?? 1}',  // e.g., "2"
                            const Color(0xFF7B1FA2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      
                      // Status badge + Arrow button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: statusColor.withOpacity(0.28),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Status dot
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: statusColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      _getStatusText(
                                          data['status'] ?? 'pending'),
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Forward arrow button
                          Material(
                            color: const Color(0xFF003465),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DonationDetailsPage(donation: data),
                                  ),
                                );
                              },
                              child: const SizedBox(
                                width: 36,
                                height: 36,
                                child: Icon(Icons.arrow_forward_ios,
                                    color: Colors.white, size: 14),
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
          ),
        ),
      ),
    );
  }

  Widget _iconTile(String iconKey) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF003465).withOpacity(0.08),
            const Color(0xFF1976D2).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          _mapIcon(iconKey),
          color: const Color(0xFF003465),
          size: 36,
        ),
      ),
    );
  }

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

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
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
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF003465).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 60,
              color: Color(0xFFAAA6B2),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No donations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003465),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your donation history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFAAA6B2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyFiltered() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF003465).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off,
              size: 50,
              color: Color(0xFFAAA6B2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No matching results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003465),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try a different search term',
            style: TextStyle(fontSize: 13, color: Color(0xFFAAA6B2)),
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
          const Icon(Icons.error_outline, size: 60, color: Color(0xFFF44336)),
          const SizedBox(height: 16),
          const Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003465),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: const TextStyle(fontSize: 12, color: Color(0xFFAAA6B2)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
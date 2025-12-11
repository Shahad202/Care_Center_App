import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationTrackingScreen extends StatefulWidget {
  const ReservationTrackingScreen({super.key});

  @override
  State<ReservationTrackingScreen> createState() =>
      _ReservationTrackingScreenState();
}

class _ReservationTrackingScreenState extends State<ReservationTrackingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _selectedStatus;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "checked out":
        return Colors.blue;
      case "returned":
        return Colors.grey;
      default:
        return Colors.black54;
    }
  }

  String _formatDate(Timestamp? ts) {
    if (ts == null) return "-";
    final d = ts.toDate();
    return "${d.day}/${d.month}/${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(child: Text("Please login to view reservations."));
    }

    final reservationStream = FirebaseFirestore.instance
        .collection('reservations')
        .where('userId', isEqualTo: uid)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A66C2),
        title: const Text("Reservation Tracking"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(height: 15),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: reservationStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0A66C2),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading data"));
                  }

                  final docs = snapshot.data?.docs ?? [];

                  if (docs.isEmpty) {
                    return const Center(child: Text("No reservations yet"));
                  }

                  final filtered = docs.where((d) {
                    final data = d.data() as Map<String, dynamic>;
                    final title = (data['itemName'] ?? '').toLowerCase();
                    final status = (data['status'] ?? '').toLowerCase();

                    final matchesSearch = title.contains(_query.toLowerCase());
                    final matchesStatus = _selectedStatus == null
                        ? true
                        : status == _selectedStatus;

                    return matchesSearch && matchesStatus;
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No matching results"));
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final data =
                          filtered[index].data() as Map<String, dynamic>;

                      return _reservationCard(data);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v.trim()),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.blue),
              hintText: "Search reservations...",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _filterButton(),
      ],
    );
  }

  Widget _filterButton() {
    final statuses = [
      "pending",
      "approved",
      "rejected",
      "checked out",
      "returned",
    ];

    return InkWell(
      onTap: () async {
        final selected = await showModalBottomSheet<String?>(
          context: context,
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                children: [
                  ChoiceChip(
                    label: const Text("All"),
                    selected: _selectedStatus == null,
                    onSelected: (_) => Navigator.pop(context, null),
                  ),
                  ...statuses.map((s) {
                    return ChoiceChip(
                      label: Text(s),
                      selected: _selectedStatus == s,
                      onSelected: (_) => Navigator.pop(context, s),
                    );
                  }),
                ],
              ),
            );
          },
        );
        if (mounted) setState(() => _selectedStatus = selected);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Color(0xFF0A66C2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.tune, color: Colors.white),
      ),
    );
  }

  Widget _reservationCard(Map<String, dynamic> data) {
    final status = data['status'] ?? 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['itemName'] ?? "Unknown item",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            "From: ${_formatDate(data['startDate'])}",
            style: const TextStyle(color: Colors.black54),
          ),
          Text(
            "To: ${_formatDate(data['endDate'])}",
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor(status).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: _statusColor(status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project444/signup.dart';
import 'package:project444/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project444/firebase_options.dart';
import 'package:project444/Reservation/reservation.dart';
import 'package:project444/donation/donor_page.dart';
import 'package:project444/profilePage.dart';
import 'dart:math' as math;
import 'package:project444/Reservation/reservation_form.dart';
import 'package:project444/Reservation/reservation_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project444/Reservation/reservation_success_screen.dart';
import 'package:project444/Reservation/reservation_form.dart';
import 'dart:math' as math;


class HowItWorksTab extends StatelessWidget {
  const HowItWorksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _stepCard('lib/images/Level1.png', 'Check Availability',
              'Select Equipment and check available dates.'),
          const SizedBox(height: 20),
          _stepCard('lib/images/2circled.png', 'Make a Reservation',
              'Choose your date range or immediate pickup.'),
          const SizedBox(height: 20),
          _stepCard('lib/images/Circled3.png', 'Confirm Reservation',
              'Submit reservation and await admin approval.'),
          const SizedBox(height: 20),
          _stepCard('lib/images/Group 2261.png', 'Rental Lifecycle',
              'Track status: Reserved -> Checked Out -> Returned -> Maintenance.'),
        ],
      ),
    );
  }

  Widget _stepCard(String img, String title, String desc) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(img), fit: BoxFit.contain)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(desc,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BrowsePageTab extends StatelessWidget {
  const BrowsePageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            _buildReserveEquipmentCard(context),
            const SizedBox(height: 20),
            _buildAvailableEquipmentSection(),
            const SizedBox(height: 20),
            _buildBrowseButton(context),
            const SizedBox(height: 20),
          ],
        ));
  }

  Widget _buildReserveEquipmentCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Color(0x14003465), offset: Offset(0, 6), blurRadius: 16)
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF003465), Color(0xFF1874CF)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 77,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('lib/images/Trusticon.png'), fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Reserve Assistive Equipment',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2),
          ),
          const SizedBox(height: 10),
          const Text(
            'Browse available items and request a rental',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFFEAF2FA), fontFamily: 'Inter', fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableEquipmentSection() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: Colors.white),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Equipment',
            style: TextStyle(
                color: Color.fromRGBO(212, 133, 18, 1),
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          _equipmentItem('lib/images/Electricwheelchair.png', 'Wheelchairs'),
          const SizedBox(height: 15),
          _equipmentItem('lib/images/Walker.png', 'Walkers & Crutches'),
          const SizedBox(height: 15),
          _equipmentItem('lib/images/Massagetable.png', 'Medical Beds'),
          const SizedBox(height: 15),
          _equipmentItem('lib/images/Sphygmomanometer.png', 'Monitors & Medical Devices'),
          const SizedBox(height: 15),
          Row(
            children: [
              Transform.rotate(
                angle: 90 * (math.pi / 180),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/images/More.png'), fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              const Text('And more...',
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'Inter', fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _equipmentItem(String imagePath, String text) {
    return Row(
      children: [
        Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.contain))),
        const SizedBox(width: 7),
        Expanded(
            child: Text(text,
                style: const TextStyle(color: Colors.black, fontFamily: 'Inter', fontSize: 14))),
      ],
    );
  }

  Widget _buildBrowseButton(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservationFormPage(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            gradient: const LinearGradient(colors: [Color(0xFFFFCC00), Color(0xFFFFB400)]),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          child: const Text('Browse Equipment',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
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

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _searchBar(),
            const SizedBox(height: 15),
            StreamBuilder<QuerySnapshot>(
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
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Text(
                        "No reservations yet.\nPlease make a reservation!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final filtered = docs.where((d) {
                  final data = d.data() as Map<String, dynamic>;
                  final title = (data['itemName'] ?? '').toLowerCase();
                  final status = (data['status'] ?? '').toLowerCase();

                  final matchesSearch = title.contains(_query.toLowerCase());
                  final matchesStatus =
                      _selectedStatus == null ? true : status == _selectedStatus;

                  return matchesSearch && matchesStatus;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50),
                    child: Text("No matching results"),
                  ));
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final data = filtered[index].data() as Map<String, dynamic>;
                    return _reservationCard(data);
                  },
                );
              },
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
                spacing: 8,
                runSpacing: 8,
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

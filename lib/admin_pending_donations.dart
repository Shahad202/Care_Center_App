import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'services/hive_service.dart';
import 'models/donation_image.dart';
import 'admin_donation_details.dart';

class AdminPendingDonations extends StatefulWidget {
  const AdminPendingDonations({super.key});

  @override
  State<AdminPendingDonations> createState() => _AdminPendingDonationsState();
}

class _AdminPendingDonationsState extends State<AdminPendingDonations> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

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

  Stream<QuerySnapshot> getAllDonations() {
    if (_auth.currentUser == null) {
      return const Stream.empty();
    }
    
    try {
      return _firestore
          .collection('donations')
          .orderBy('createdAt', descending: true)
          .snapshots();
    } catch (error) {
      print('Error fetching donations: $error');
      return const Stream.empty();
    }
  }

  Widget _buildImageFromHive(String imageId) {
    return FutureBuilder<DonationImage?>(
      future: HiveService.getImage(imageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _placeholderIcon();
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return _placeholderIcon();
        }

        final image = snapshot.data!;

        return Image.memory(
          Uint8List.fromList(image.imageBytes),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _placeholderIcon();
          },
        );
      },
    );
  }

  Widget _placeholderIcon() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF003465).withOpacity(0.1),
            const Color(0xFF1976D2).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(
          Icons.medical_services_outlined,
          color: Color(0xFF003465),
          size: 40,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Donations'),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAllDonations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Go to Login'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No donations available',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final imageIds = List<String>.from(data['imageIds'] ?? []);
              final itemName = data['itemName'] ?? 'Unknown Item';
              final quantity = data['quantity'] ?? 0;
              final status = data['status'] ?? 'pending';
              final createdAt = data['createdAt'] as Timestamp?;
              
              String formattedDate = 'N/A';
              if (createdAt != null) {
                final date = createdAt.toDate();
                formattedDate =
                    '${date.day} ${_getMonthName(date.month)} ${date.year}';
              }

              Color statusColor = status == 'approved' 
                  ? Colors.green 
                  : status == 'rejected' 
                      ? Colors.red 
                      : Colors.orange;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: imageIds.isNotEmpty
                        ? _buildImageFromHive(imageIds.first)
                        : Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          ),
                  ),
                  title: Text(
                    itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text('Qty: $quantity'),
                      Text(
                        'Submitted: $formattedDate',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AdminDonationDetails(
                            donationId: docs[index].id,
                            donationData: data,
                          ),
                        ),
                      );
                    },
                    child: const Text('View'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
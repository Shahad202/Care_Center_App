import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/hive_service.dart';
import '../models/donation_image.dart';
import 'dart:typed_data';

class AdminDonationDetails extends StatefulWidget {
  final String donationId;
  final Map<String, dynamic> donationData;

  const AdminDonationDetails({
    super.key,
    required this.donationId,
    required this.donationData,
  });

  @override
  State<AdminDonationDetails> createState() => _AdminDonationDetailsState();
}

class _AdminDonationDetailsState extends State<AdminDonationDetails> {
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Widget _buildImageFromHive(String imageId) {
    return FutureBuilder<DonationImage?>(
      future: HiveService.getImage(imageId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.grey.shade300,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Container(
            color: Colors.grey.shade300,
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.white, size: 60),
            ),
          );
        }

        final image = snapshot.data!;
        return Image.memory(
          Uint8List.fromList(image.imageBytes),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade300,
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.white, size: 60),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _approveDonation() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final data = widget.donationData;

      await _firestore.collection('donations').doc(widget.donationId).update({
        'status': 'approved',
        'approvedAt': Timestamp.now(),
      });

      await _firestore.collection('inventory').add({
        'name': data['itemName'] ?? 'Unknown',
        'condition': data['condition'] ?? 'Good',
        'description': data['description'] ?? '',
        'quantity': data['quantity'] ?? 0,
        'location': data['location'] ?? 'Not specified',
        'imageIds': data['imageIds'] ?? [],
        'status': 'available',
        'source': 'donation',
        'donorId': data['donorId'] ?? '',
        'donationId': widget.donationId,
        'createdAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation approved and added to inventory!'),
            backgroundColor: Colors.green,
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pop(context);
        });
      }
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _rejectDonation() async {
    if (_isLoading) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Donation'),
        content: const Text('Are you sure you want to reject this donation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
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
      await _firestore.collection('donations').doc(widget.donationId).update({
        'status': 'rejected',
        'rejectedAt': Timestamp.now(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation rejected'),
            backgroundColor: Colors.orange,
          ),
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) Navigator.pop(context);
        });
      }
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
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.donationData;
    final imageIds = List<String>.from(data['imageIds'] ?? []);
    final status = data['status'] ?? 'pending';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageIds.isNotEmpty)
                  SizedBox(
                    height: 250,
                    child: PageView.builder(
                      itemCount: imageIds.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _buildImageFromHive(imageIds[index]),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 24),

                _buildInfoSection('Item Name', data['itemName'] ?? 'N/A'),
                const SizedBox(height: 16),
                _buildInfoSection('Quantity', '${data['quantity'] ?? 0}'),
                const SizedBox(height: 16),
                _buildInfoSection('Condition', data['condition'] ?? 'N/A'),
                const SizedBox(height: 16),
                _buildInfoSection('Location', data['location'] ?? 'N/A'),
                const SizedBox(height: 16),
                _buildInfoSection('Description', data['description'] ?? 'N/A'),
                const SizedBox(height: 16),
                _buildInfoSection('Status', status.toUpperCase()),
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isLoading ? null : _rejectDonation,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Reject',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isLoading ? null : _approveDonation,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Approve & Add',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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

  Widget _buildInfoSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationItem {
  final String id;
  final String itemName;
  final String condition;
  final String description;
  final int quantity;
  final String location;
  final String status;
  final DateTime createdAt;
  final List<String> imageUrls;
  final String? donorId;

  DonationItem({
    required this.id,
    required this.itemName,
    required this.condition,
    required this.description,
    required this.quantity,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.imageUrls,
    required this.donorId,
  });

  factory DonationItem.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return DonationItem(
      id: doc.id,
      itemName: d['itemName'] ?? '',
      condition: d['condition'] ?? '',
      description: d['description'] ?? '',
      quantity: int.tryParse(d['quantity']?.toString() ?? '0') ?? 0,
      location: d['location'] ?? '',
      status: d['status'] ?? 'pending',
      createdAt: (d['createdAt'] is Timestamp)
          ? (d['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      imageUrls: (d['imageUrls'] as List?)?.cast<String>() ?? [],
      donorId: d['donorId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'condition': condition,
      'description': description,
      'quantity': quantity,
      'location': location,
      'status': status,
      'imageUrls': imageUrls,
      'donorId': donorId,
      'createdAt': createdAt,
    };
  }
}
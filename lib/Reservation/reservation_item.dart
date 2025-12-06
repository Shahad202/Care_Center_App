import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationItem {
  final String id;
  final String equipmentName;
  final int quantity;
  final String notes;
  final String userId;
  final String status;
  final DateTime createdAt;

  ReservationItem({
    required this.id,
    required this.equipmentName,
    required this.quantity,
    required this.notes,
    required this.userId,
    required this.status,
    required this.createdAt,
  });

  factory ReservationItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReservationItem(
      id: doc.id,
      equipmentName: data['equipmentName'] ?? '',
      quantity: data['quantity'] ?? 0,
      notes: data['notes'] ?? '',
      userId: data['userId'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

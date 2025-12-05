import 'package:cloud_firestore/cloud_firestore.dart';

class DonationItem {
  String id;
  String itemName;
  String condition;
  String description;
  int quantity;
  String location;
  String status;
  String donorId;
  List<String> imageIds;
  DateTime createdAt;
  String iconKey;

  DonationItem({
    required this.id,
    required this.itemName,
    required this.condition,
    required this.description,
    required this.quantity,
    required this.location,
    required this.status,
    required this.donorId,
    required this.imageIds,
    required this.createdAt,
    required this.iconKey,
  });

  factory DonationItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DonationItem(
      id: doc.id,
      itemName: data['itemName'] ?? '',
      condition: data['condition'] ?? '',
      description: data['description'] ?? '',
      quantity: data['quantity'] ?? 0,
      location: data['location'] ?? '',
      status: data['status'] ?? 'pending',
      donorId: data['donorId'] ?? '',
      imageIds: List<String>.from(data['imageIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      iconKey: data['iconKey'] ?? 'default',
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
      'donorId': donorId,
      'imageIds': imageIds,
      'createdAt': createdAt,
      'iconKey': iconKey,
    };
  }
}
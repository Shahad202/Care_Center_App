import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'donation_item.g.dart';

@HiveType(typeId: 1)
class DonationItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String itemName;

  @HiveField(2)
  String condition;

  @HiveField(3)
  String description;

  @HiveField(4)
  int quantity;

  @HiveField(5)
  String location;

  @HiveField(6)
  String status;

  @HiveField(7)
  String donorId;

  @HiveField(8)
  List<String> imageIds;

  @HiveField(9)
  DateTime createdAt;

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
    };
  }
}
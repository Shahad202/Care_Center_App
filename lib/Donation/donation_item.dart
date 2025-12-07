import 'package:cloud_firestore/cloud_firestore.dart';

class DonationItem {
  // All the properties/fields of a donation
  String id;                    // Unique document ID from Firestore
  String itemName;              // What's being donated (e.g., "Wheelchair")
  String condition;             // Condition level (New, Like New, Good, Fair, Needs Repair)
  String description;           // Optional details about the item
  int quantity;                 // How many items being donated
  String location;              // Pickup location (e.g., "Downtown")
  String status;                // Status: pending, approved, or rejected
  String donorId;               // User ID of the person donating
  List<String> imageIds;        // List of image IDs (for future image uploads)
  DateTime createdAt;           // When the donation was submitted
  String iconKey;               // Icon type: wheelchair, walker, crutches, etc.

  // Constructor - creates a new DonationItem with all required fields
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

  // Factory Constructor - converts Firestore document to DonationItem
  factory DonationItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    // Ensure quantity is always > 0 (default to 1 if missing or invalid)
    int qty = data['quantity'] ?? 0;
    if (qty <= 0) qty = 1;
    
    return DonationItem(
      id: doc.id,                                              // Document ID from Firestore
      itemName: data['itemName'] ?? '',                        // Get from Firestore or empty string
      condition: data['condition'] ?? '',
      description: data['description'] ?? '',
      quantity: qty,                                           // Validated quantity (always > 0)
      location: data['location'] ?? '',
      status: data['status'] ?? 'pending',                     // Default to 'pending' if missing
      donorId: data['donorId'] ?? '',
      imageIds: List<String>.from(data['imageIds'] ?? []),    // Convert to List<String>
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),  // Convert Timestamp to DateTime
      iconKey: data['iconKey'] ?? 'default',                   // Default icon if missing
    );
  }

  // Convert DonationItem back to Map for storage
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
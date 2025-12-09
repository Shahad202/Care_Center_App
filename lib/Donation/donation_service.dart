import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'donation_item.dart';

class DonationService {
  final _firestore = FirebaseFirestore.instance;

  Future<DonationItem> addDonation({
    required String itemName,
    required String condition,
    required String description,
    required int quantity,
    required String location,
    required String iconKey,
  }) async {
    print('\n=== DonationService.addDonation Started ===');
    
    // STEP 1: Authentication check
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');
    print('Creating Firestore document...');

    try {
      // STEP 2: Write to Firestore 'donations' collection
      final docRef = await _firestore.collection('donations').add({
        'itemName': itemName,
        'condition': condition,
        'description': description,
        'quantity': quantity,
        'location': location,
        'status': 'pending',           // New donations start as pending
        'imageIds': <String>[],        // Empty for now (can add image upload later)
        'iconKey': iconKey,            // The icon user selected
        'donorId': user.uid,           // Link to current user
        'createdAt': FieldValue.serverTimestamp(),  // Server timestamp
      });

      print('Document created: ${docRef.id}');

      // STEP 3: Fetch the newly created document
      final snap = await docRef.get();
      
      // STEP 4: Convert to DonationItem object
      final donationItem = DonationItem.fromDoc(snap);
      print('Donation created successfully');
      print('=== addDonation completed ===\n');
      
      // STEP 5: Return the donation item
      return donationItem;
      
    } on FirebaseException catch (e) {
      // Firebase-specific error handling
      print('Firebase error: ${e.code} - ${e.message}');
      throw Exception('Firebase error: ${e.message}');
    } catch (e, stackTrace) {
      // General error handling
      print('Error: $e');
      print('Stack: $stackTrace');
      throw Exception('Failed to submit donation: $e');
    }
  }
}
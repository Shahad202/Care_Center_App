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
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');
    print('Creating Firestore document...');

    try {
      final docRef = await _firestore.collection('donations').add({
        'itemName': itemName,
        'condition': condition,
        'description': description,
        'quantity': quantity,
        'location': location,
        'status': 'pending',
        'imageIds': <String>[],
        'iconKey': iconKey,
        'donorId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Document created: ${docRef.id}');

      final snap = await docRef.get();
      final donationItem = DonationItem.fromDoc(snap);
      print('Donation created successfully');
      print('=== addDonation completed ===\n');
      
      return donationItem;
      
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.code} - ${e.message}');
      throw Exception('Firebase error: ${e.message}');
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack: $stackTrace');
      throw Exception('Failed to submit donation: $e');
    }
  }
}
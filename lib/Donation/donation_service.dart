import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/hive_service.dart';
import 'donation_item.dart';

class DonationService {
  final _firestore = FirebaseFirestore.instance;

  Future<DonationItem> addDonation({
    required String itemName,
    required String condition,
    required String description,
    required int quantity,
    required String location,
    required List<XFile> images,
  }) async {
    print('\n=== DonationService.addDonation Started ===');
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');

    print('Processing ${images.length} images...');
    
    if (images.isEmpty) {
      throw Exception('No images provided. Please add at least one photo.');
    }

    final List<String> imageIds = [];
    final tempDonationId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    int successCount = 0;
    int failureCount = 0;

    try {
      for (int i = 0; i < images.length; i++) {
        final xfile = images[i];
        print('\n--- Processing image ${i + 1}/${images.length} ---');
        print('Name: ${xfile.name}');
        print('Path: ${xfile.path}');
        
        try {
          List<int> imageBytes;
          try {
            imageBytes = await xfile.readAsBytes();
          } catch (e) {
            print('readAsBytes failed: $e');
            failureCount++;
            continue;
          }
          
          print('Bytes length: ${imageBytes.length}');
          
          if (imageBytes.isEmpty) {
            print('Image bytes are empty');
            failureCount++;
            continue;
          }

          if (imageBytes.length > 50 * 1024 * 1024) {
            print('Image too large (${imageBytes.length} bytes)');
            failureCount++;
            continue;
          }
          
          try {
            final imageId = await HiveService.saveImage(
              donationId: tempDonationId,
              imageBytes: imageBytes,
              fileName: xfile.name,
            );
            
            imageIds.add(imageId);
            successCount++;
            print('Saved successfully with ID: $imageId');
          } catch (e) {
            print('HiveService.saveImage failed: $e');
            failureCount++;
            continue;
          }
          
        } catch (e, st) {
          print('Unexpected error: $e');
          print('Stack: $st');
          failureCount++;
          continue;
        }
      }

      print('\n=== Image Processing Summary ===');
      print('Total: ${images.length}');
      print('Success: $successCount');
      print('Failed: $failureCount');

      if (imageIds.isEmpty) {
        await HiveService.deleteDonationImages(imageIds);
        throw Exception('Failed to process any images. Please try again.');
      }

      print('\nCreating Firestore document...');

      final docRef = await _firestore.collection('donations').add({
        'itemName': itemName,
        'condition': condition,
        'description': description,
        'quantity': quantity,
        'location': location,
        'status': 'pending',
        'imageIds': imageIds,
        'donorId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Document created: ${docRef.id}');

      for (final imageId in imageIds) {
        await HiveService.updateDonationIds([imageId], docRef.id);
      }

      print('Image IDs updated');

      final snap = await docRef.get();
      final donationItem = DonationItem.fromDoc(snap);
      print('Donation created successfully');
      print('=== addDonation completed ===\n');
      
      return donationItem;
      
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.code} - ${e.message}');
      await HiveService.deleteDonationImages(imageIds);
      throw Exception('Firebase error: ${e.message}');
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack: $stackTrace');
      await HiveService.deleteDonationImages(imageIds);
      throw Exception('Failed to submit donation: $e');
    }
  }
}
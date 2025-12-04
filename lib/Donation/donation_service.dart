import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../services/hive_service.dart';
import '../models/donation_image.dart';
import 'donation_item.dart';

class DonationService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<String>> _processAndSaveImages(List<XFile> images, String tempDonationId) async {
    final imageIds = <String>[];
    
    for (int i = 0; i < images.length; i++) {
      final image = images[i];
      try {
        print('Processing image ${i + 1}/${images.length}...');
        
        final bytes = await image.readAsBytes();
        print('   - Original size: ${(bytes.length / 1024).toStringAsFixed(2)} KB');
        
        if (bytes.isEmpty) {
          print('Warning: Image ${i + 1} has no bytes!');
          continue;
        }

        img.Image? originalImage = img.decodeImage(bytes);
        if (originalImage == null) {
          print('Warning: Could not decode image ${i + 1}');
          continue;
        }

        print('   - Original dimensions: ${originalImage.width}x${originalImage.height}');

        img.Image resizedImage = originalImage;
        if (originalImage.width > 800 || originalImage.height > 800) {
          resizedImage = img.copyResize(
            originalImage,
            width: originalImage.width > originalImage.height ? 800 : null,
            height: originalImage.height >= originalImage.width ? 800 : null,
          );
          print('   - Resized to: ${resizedImage.width}x${resizedImage.height}');
        }

        final compressedBytes = img.encodeJpg(resizedImage, quality: 70);
        print('   - Compressed size: ${(compressedBytes.length / 1024).toStringAsFixed(2)} KB');
        
        if (compressedBytes.length > 800 * 1024) {
          print('Warning: Image ${i + 1} still too large, compressing more...');
          final moreCompressed = img.encodeJpg(resizedImage, quality: 50);
          print('   - Re-compressed size: ${(moreCompressed.length / 1024).toStringAsFixed(2)} KB');
          
          if (moreCompressed.length > 800 * 1024) {
            print('Error: Image ${i + 1} too large, skipping');
            continue;
          }
          
          final imageId = await HiveService.saveImage(
            donationId: tempDonationId,
            imageBytes: moreCompressed,
            fileName: image.name,
          );
          imageIds.add(imageId);
          print('Image ${i + 1} processed successfully (quality 50%)');
        } else {
          final imageId = await HiveService.saveImage(
            donationId: tempDonationId,
            imageBytes: compressedBytes,
            fileName: image.name,
          );
          imageIds.add(imageId);
          print('Image ${i + 1} processed successfully (quality 70%)');
        }
        
      } catch (e, stackTrace) {
        print('Error processing image ${i + 1}: $e');
        print('Stack trace: $stackTrace');
      }
    }
    
    print('Total images processed: ${imageIds.length}/${images.length}');
    return imageIds;
  }

  Future<DonationItem> addDonation({
    required String itemName,
    required String condition,
    required String description,
    required int quantity,
    required String location,
    required List<XFile> images,
  }) async {
    print('\n===  DonationService.addDonation ===');
    
    final user = _auth.currentUser;
    if (user == null) {
      print('No authenticated user');
      throw Exception('User must be logged in to submit a donation.');
    }
    print('User authenticated: ${user.uid}');

    if (images.isEmpty) {
      print('No images provided');
      throw Exception('Please add at least one image');
    }

    final tempDonationId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    
    print('Converting images to bytes and saving to Hive...');
    final imageIds = await _processAndSaveImages(images, tempDonationId);
    
    if (imageIds.isEmpty) {
      print('Failed to convert images');
      throw Exception('Failed to convert any images. Please try again with different images.');
    }

    print('Images saved to Hive: ${imageIds.length}');
    try {
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

      print('Document created with ID: ${docRef.id}');

      for (String imageId in imageIds) {
        final image = await HiveService.getImage(imageId);
        if (image != null) {
          final updatedImage = DonationImage(
            id: image.id,
            donationId: docRef.id,
            imageBytes: image.imageBytes,
            fileName: image.fileName,
            createdAt: image.createdAt,
          );
          await HiveService.saveImage(
            donationId: docRef.id,
            imageBytes: updatedImage.imageBytes,
            fileName: updatedImage.fileName,
          );
        }
      }

      print('Image IDs updated with donation ID');

      final snap = await docRef.get();
      final donationItem = DonationItem.fromDoc(snap);
      print('DonationItem created successfully');
      print('=== addDonation completed ===\n');
      
      return donationItem;
      
    } on FirebaseException catch (e) {
      print('Firebase error: ${e.code}');
      print('   Message: ${e.message}');
      
      await HiveService.deleteDonationImages(tempDonationId);
      
      throw Exception('Firebase error (${e.code}): ${e.message}');
    } catch (e, stackTrace) {
      print('Unexpected error: $e');
      print('Stack trace: $stackTrace');
      
      await HiveService.deleteDonationImages(tempDonationId);
      
      throw Exception('Failed to add donation: $e');
    }
  }

  Stream<List<DonationItem>> userDonationsStream({bool onlyCurrentUser = true}) {
    Query q = _firestore.collection('donations').orderBy('createdAt', descending: true);

    if (onlyCurrentUser) {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        q = q.where('donorId', isEqualTo: uid);
      } else {
        q = q.where('donorId', isEqualTo: '__none__');
      }
    }

    return q.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => DonationItem.fromDoc(doc)).toList();
    });
  }
}
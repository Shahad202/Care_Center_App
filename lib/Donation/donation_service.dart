import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'donation_item.dart';

class DonationService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // ضغط وتحويل الصور إلى base64
  Future<List<String>> _convertImagesToBase64(List<XFile> images) async {
    final base64Images = <String>[];
    
    for (int i = 0; i < images.length; i++) {
      final image = images[i];
      try {
        print('📸 Processing image ${i + 1}/${images.length}...');
        print('   - Original path: ${image.path}');
        
        // قراءة الصورة
        final bytes = await image.readAsBytes();
        print('   - Original size: ${bytes.length} bytes (${(bytes.length / 1024).toStringAsFixed(2)} KB)');
        
        if (bytes.isEmpty) {
          print('⚠️ Warning: Image ${i + 1} has no bytes!');
          continue;
        }

        // فك تشفير الصورة
        img.Image? originalImage = img.decodeImage(bytes);
        if (originalImage == null) {
          print('⚠️ Warning: Could not decode image ${i + 1}');
          continue;
        }

        print('   - Original dimensions: ${originalImage.width}x${originalImage.height}');

        // تصغير الصورة إذا كانت كبيرة (الحد الأقصى 800px)
        img.Image resizedImage = originalImage;
        if (originalImage.width > 800 || originalImage.height > 800) {
          resizedImage = img.copyResize(
            originalImage,
            width: originalImage.width > originalImage.height ? 800 : null,
            height: originalImage.height >= originalImage.width ? 800 : null,
          );
          print('   - Resized to: ${resizedImage.width}x${resizedImage.height}');
        }

        // ضغط الصورة بجودة 70%
        final compressedBytes = img.encodeJpg(resizedImage, quality: 70);
        print('   - Compressed size: ${compressedBytes.length} bytes (${(compressedBytes.length / 1024).toStringAsFixed(2)} KB)');
        
        // التحقق من أن الحجم مقبول (أقل من 800KB)
        if (compressedBytes.length > 800 * 1024) {
          print('⚠️ Warning: Image ${i + 1} still too large after compression, compressing more...');
          // ضغط أكثر بجودة 50%
          final moreCompressed = img.encodeJpg(resizedImage, quality: 50);
          print('   - Re-compressed size: ${moreCompressed.length} bytes (${(moreCompressed.length / 1024).toStringAsFixed(2)} KB)');
          
          if (moreCompressed.length > 800 * 1024) {
            print('❌ Error: Image ${i + 1} too large even after aggressive compression, skipping');
            continue;
          }
          
          final base64String = base64Encode(moreCompressed);
          base64Images.add(base64String);
          print('✅ Image ${i + 1} processed successfully (quality 50%)');
        } else {
          final base64String = base64Encode(compressedBytes);
          base64Images.add(base64String);
          print('✅ Image ${i + 1} processed successfully (quality 70%)');
        }
        
      } catch (e, stackTrace) {
        print('❌ Error processing image ${i + 1}: $e');
        print('Stack trace: $stackTrace');
      }
    }
    
    print('🎉 Total images processed: ${base64Images.length}/${images.length}');
    
    // حساب الحجم الإجمالي
    int totalSize = 0;
    for (final img in base64Images) {
      totalSize += img.length;
    }
    print('📊 Total base64 size: ${totalSize} bytes (${(totalSize / 1024).toStringAsFixed(2)} KB)');
    
    if (totalSize > 1000000) {
      print('⚠️ WARNING: Total size exceeds 1MB Firestore limit!');
      throw Exception('Images too large. Please use fewer or smaller images.');
    }
    
    return base64Images;
  }

  Future<DonationItem> addDonation({
    required String itemName,
    required String condition,
    required String description,
    required int quantity,
    required String location,
    required List<XFile> images,
  }) async {
    print('\n=== 🚀 DonationService.addDonation ===');
    
    final user = _auth.currentUser;
    if (user == null) {
      print('❌ No authenticated user');
      throw Exception('User must be logged in to submit a donation.');
    }
    print('✅ User authenticated: ${user.uid}');

    print('📋 Donation details:');
    print('   - Item: $itemName');
    print('   - Condition: $condition');
    print('   - Description: ${description.isEmpty ? "(empty)" : description}');
    print('   - Quantity: $quantity');
    print('   - Location: $location');
    print('   - Images: ${images.length}');
    
    if (images.isEmpty) {
      print('❌ No images provided');
      throw Exception('Please add at least one image');
    }

    // تحويل الصور إلى base64
    print('🔄 Converting images to base64...');
    final base64Images = await _convertImagesToBase64(images);
    
    if (base64Images.isEmpty) {
      print('❌ Failed to convert images');
      throw Exception('Failed to convert any images to base64. Please try again with different images.');
    }

    print('✅ Images converted successfully: ${base64Images.length}');
    print('   - First image length: ${base64Images.first.length} characters');

    try {
      final data = {
        'itemName': itemName,
        'condition': condition,
        'description': description,
        'quantity': quantity,
        'location': location,
        'status': 'pending',
        'imageUrls': base64Images,
        'donorId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      print('📤 Sending to Firestore...');
      print('   - Collection: donations');
      print('   - Data keys: ${data.keys.join(", ")}');
      
      final docRef = await _firestore.collection('donations').add(data);
      print('✅ Document created with ID: ${docRef.id}');

      print('📥 Fetching saved document...');
      final snap = await docRef.get();
      
      if (!snap.exists) {
        print('❌ Document not found after creation!');
        throw Exception('Document was created but not found');
      }
      
      print('✅ Document fetched successfully');
      
      // التحقق من البيانات المحفوظة
      final savedData = snap.data() as Map<String, dynamic>?;
      if (savedData != null) {
        print('✅ Saved data verification:');
        print('   - Item: ${savedData['itemName']}');
        print('   - Status: ${savedData['status']}');
        
        final savedImages = (savedData['imageUrls'] as List?)?.cast<String>() ?? [];
        print('   - Images count: ${savedImages.length}');
        
        if (savedImages.isNotEmpty) {
          print('   - First image length: ${savedImages.first.length}');
        } else {
          print('   ⚠️ No images in saved data!');
        }
      } else {
        print('⚠️ No data in snapshot');
      }
      
      final donationItem = DonationItem.fromDoc(snap);
      print('✅ DonationItem created successfully');
      print('=== ✅ addDonation completed ===\n');
      
      return donationItem;
      
    } on FirebaseException catch (e) {
      print('❌ Firebase error: ${e.code}');
      print('   Message: ${e.message}');
      print('   Stack: ${e.stackTrace}');
      throw Exception('Firebase error (${e.code}): ${e.message}');
    } catch (e, stackTrace) {
      print('❌ Unexpected error: $e');
      print('Stack trace: $stackTrace');
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
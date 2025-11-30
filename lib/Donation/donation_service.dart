import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'donation_item.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DonationService {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  DonationService() {
    // Emulator example (optional):
    // if (kIsWeb || kDebugMode) {
    //   _storage.useStorageEmulator('localhost', 9199);
    // }
  }

  Future<List<String>> _uploadImages(List<XFile> images) async {
    final urls = <String>[];

    for (final x in images) {
      try {
        final bytes = await x.readAsBytes();
        final ext = x.name.split('.').last.toLowerCase();
        final ref = _storage
            .ref()
            .child('donations/${DateTime.now().millisecondsSinceEpoch}_${x.name}');
        final uploadTask = await ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/$ext'),
        );
        final url = await uploadTask.ref.getDownloadURL();
        urls.add(url);
      } on FirebaseException catch (e) {
        print('Upload error: ${e.code} - ${e.message}');
        throw FirebaseException(
          plugin: 'firebase_storage',
          code: e.code,
          message: 'Failed to upload image. Please try again later.',
        );
      } catch (e) {
        print('Unexpected error: $e');
        throw Exception('Failed to upload image due to an unexpected error.');
      }
    }

    if (urls.isEmpty && images.isNotEmpty) {
      throw Exception('Failed to upload all images. Please check Firebase Storage configuration.');
    }

    return urls;
  }

  Future<DonationItem> addDonation({
    required String itemName,
    required String condition,
    required String description,
    required int quantity,
    required String location,
    required List<XFile> images,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseException(
        plugin: 'firebase_auth',
        code: 'unauthenticated',
        message: 'User must be logged in to submit a donation.',
      );
    }

    final imageUrls = await _uploadImages(images);

    try {
      final docRef = await _firestore.collection('donations').add({
        'itemName': itemName,
        'condition': condition,
        'description': description,
        'quantity': quantity,
        'location': location,
        'status': 'pending',
        'imageUrls': imageUrls,
        'donorId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final snap = await docRef.get();
      return DonationItem.fromDoc(snap);
    } on FirebaseException catch (e) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        code: e.code,
        message: e.message,
      );
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
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../models/donation_image.dart';

class HiveService {
  static const String donationImagesBox = 'donation_images';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DonationImageAdapter());
    }
    if (!Hive.isBoxOpen(donationImagesBox)) {
      await Hive.openBox<DonationImage>(donationImagesBox);
    }
  }

  static Future<Box<DonationImage>> _box() async {
    if (!Hive.isBoxOpen(donationImagesBox)) {
      await Hive.openBox<DonationImage>(donationImagesBox);
    }
    return Hive.box<DonationImage>(donationImagesBox);
  }

  static Future<String> saveImage({
    required String donationId,
    required List<int> imageBytes,
    required String fileName,
  }) async {
    final box = await _box();
    final imageId = const Uuid().v4();
    
    print('Saving image to Hive: $fileName');
    print('Image size: ${imageBytes.length} bytes');
    
    final donationImage = DonationImage(
      id: imageId,
      donationId: donationId,
      imagePath: imageId,
      fileName: fileName,
      createdAt: DateTime.now(),
      imageBytes: imageBytes,
    );
    
    await box.put(imageId, donationImage);
    print('Image saved to Hive successfully: $imageId');
    return imageId;
  }

  static Future<DonationImage?> getImage(String imageId) async {
    final box = await _box();
    final image = box.get(imageId);
    
    if (image != null && image.imageBytes.isNotEmpty) {
      print('Image retrieved from Hive: $imageId');
      return image;
    }
    
    return null;
  }

  static Future<void> updateDonationIds(
      List<String> imageIds, String donationId) async {
    final box = await _box();
    for (final id in imageIds) {
      final img = box.get(id);
      if (img != null) {
        img.donationId = donationId;
        await box.put(id, img);
      }
    }
  }

  static Future<void> deleteDonationImages(List<String> imageIds) async {
    final box = await _box();
    await box.deleteAll(imageIds);
    print('Deleted ${imageIds.length} images from Hive');
  }
}
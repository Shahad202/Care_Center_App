import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
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
    
    print('✅ Hive initialized successfully');
  }

  static Future<String> saveImage({
    required String donationId,
    required List<int> imageBytes,
    required String fileName,
  }) async {
    try {
      final imageId = const Uuid().v4();
      
      final donationImage = DonationImage(
        id: imageId,
        donationId: donationId,
        imageBytes: imageBytes,
        fileName: fileName,
        createdAt: DateTime.now(),
      );

      final box = Hive.box<DonationImage>(donationImagesBox);
      await box.put(imageId, donationImage);

      print('Image saved with ID: $imageId');
      return imageId;
    } catch (e) {
      print('Error saving image: $e');
      rethrow;
    }
  }

  static Future<DonationImage?> getImage(String imageId) async {
    try {
      final box = Hive.box<DonationImage>(donationImagesBox);
      return box.get(imageId);
    } catch (e) {
      print('Error getting image: $e');
      return null;
    }
  }

  static Future<List<DonationImage>> getDonationImages(String donationId) async {
    try {
      final box = Hive.box<DonationImage>(donationImagesBox);
      final images = box.values
          .where((img) => img.donationId == donationId)
          .toList();

      print('Retrieved ${images.length} images for donation $donationId');
      return images;
    } catch (e) {
      print('Error getting donation images: $e');
      return [];
    }
  }

  static Future<void> deleteImage(String imageId) async {
    try {
      final box = Hive.box<DonationImage>(donationImagesBox);
      await box.delete(imageId);
      print('Image deleted: $imageId');
    } catch (e) {
      print('Error deleting image: $e');
      rethrow;
    }
  }

  static Future<void> deleteDonationImages(String donationId) async {
    try {
      final box = Hive.box<DonationImage>(donationImagesBox);
      final keysToDelete = <dynamic>[];
      
      for (var key in box.keys) {
        final image = box.get(key);
        if (image?.donationId == donationId) {
          keysToDelete.add(key);
        }
      }

      for (var key in keysToDelete) {
        await box.delete(key);
      }

      print('Deleted ${keysToDelete.length} images for donation $donationId');
    } catch (e) {
      print('Error deleting donation images: $e');
      rethrow;
    }
  }

  static Future<int> getTotalImageSize() async {
    try {
      final box = Hive.box<DonationImage>(donationImagesBox);
      int totalSize = 0;

      for (var image in box.values) {
        totalSize += image.imageBytes.length;
      }

      print('Total image size: ${(totalSize / 1024 / 1024).toStringAsFixed(2)} MB');
      return totalSize;
    } catch (e) {
      print('Error calculating size: $e');
      return 0;
    }
  }

  static Future<void> clearAllImages() async {
    try {
      final box = Hive.box<DonationImage>(donationImagesBox);
      await box.clear();
      print('All images cleared from Hive');
    } catch (e) {
      print('Error clearing images: $e');
      rethrow;
    }
  }
}
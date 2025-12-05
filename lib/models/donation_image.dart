import 'package:hive/hive.dart';
part 'donation_image.g.dart';

@HiveType(typeId: 0)
class DonationImage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String donationId;

  @HiveField(2)
  final String imagePath; // مستخدم فقط للموبايل

  @HiveField(3)
  final String fileName;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final List<int> imageBytes; // للويب والموبايل

  DonationImage({
    required this.id,
    required this.donationId,
    required this.imagePath,
    required this.fileName,
    required this.createdAt,
    required this.imageBytes,
  });
}
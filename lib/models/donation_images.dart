import 'package:hive/hive.dart';

part 'donation_images.g.dart';

@HiveType(typeId: 0)
class DonationImage extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String donationId;

  @HiveField(2)
  List<int> imageBytes;

  @HiveField(3)
  String fileName;

  @HiveField(4)
  DateTime createdAt;

  DonationImage({
    required this.id,
    required this.donationId,
    required this.imageBytes,
    required this.fileName,
    required this.createdAt,
  });
}
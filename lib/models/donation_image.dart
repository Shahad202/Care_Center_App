import 'package:hive/hive.dart';

part 'donation_image.g.dart';

@HiveType(typeId: 0)
class DonationImage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  late String donationId;

  @HiveField(2)
  final List<int> imageBytes;

  @HiveField(3)
  final String fileName;

  @HiveField(4)
  final DateTime createdAt;

  DonationImage({
    required this.id,
    required this.donationId,
    required this.imageBytes,
    required this.fileName,
    required this.createdAt,
  });
}
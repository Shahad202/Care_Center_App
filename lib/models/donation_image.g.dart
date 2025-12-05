part of 'donation_image.dart';

class DonationImageAdapter extends TypeAdapter<DonationImage> {
  @override
  final int typeId = 0;

  @override
  DonationImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DonationImage(
      id: fields[0] as String,
      donationId: fields[1] as String,
      imagePath: fields[2] as String,
      fileName: fields[3] as String,
      createdAt: fields[4] as DateTime,
      imageBytes: (fields[5] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, DonationImage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.donationId)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.fileName)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.imageBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonationImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

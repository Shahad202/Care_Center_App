part of 'donation_item.dart';

class DonationItemAdapter extends TypeAdapter<DonationItem> {
  @override
  final int typeId = 1;

  @override
  DonationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DonationItem(
      id: fields[0] as String,
      itemName: fields[1] as String,
      condition: fields[2] as String,
      description: fields[3] as String,
      quantity: fields[4] as int,
      location: fields[5] as String,
      status: fields[6] as String,
      donorId: fields[7] as String,
      imageIds: (fields[8] as List).cast<String>(),
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DonationItem obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.condition)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.donorId)
      ..writeByte(8)
      ..write(obj.imageIds)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DonationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

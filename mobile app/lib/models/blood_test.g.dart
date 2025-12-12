// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_test.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BloodTestAdapter extends TypeAdapter<BloodTest> {
  @override
  final int typeId = 0;

  @override
  BloodTest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BloodTest(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      hgb: fields[2] as double,
      rbc: fields[3] as double,
      wbc: fields[4] as double,
      plt: fields[5] as double,
      lymp: fields[6] as double,
      mono: fields[7] as double,
      hct: fields[8] as double,
      mcv: fields[9] as double,
      mch: fields[10] as double,
      mchc: fields[11] as double,
      rdw: fields[12] as double,
      pdw: fields[13] as double,
      mpv: fields[14] as double,
      pct: fields[15] as double,
      imagePath: fields[16] as String?,
      diagnosis: (fields[17] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, BloodTest obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.hgb)
      ..writeByte(3)
      ..write(obj.rbc)
      ..writeByte(4)
      ..write(obj.wbc)
      ..writeByte(5)
      ..write(obj.plt)
      ..writeByte(6)
      ..write(obj.lymp)
      ..writeByte(7)
      ..write(obj.mono)
      ..writeByte(8)
      ..write(obj.hct)
      ..writeByte(9)
      ..write(obj.mcv)
      ..writeByte(10)
      ..write(obj.mch)
      ..writeByte(11)
      ..write(obj.mchc)
      ..writeByte(12)
      ..write(obj.rdw)
      ..writeByte(13)
      ..write(obj.pdw)
      ..writeByte(14)
      ..write(obj.mpv)
      ..writeByte(15)
      ..write(obj.pct)
      ..writeByte(16)
      ..write(obj.imagePath)
      ..writeByte(17)
      ..write(obj.diagnosis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BloodTestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

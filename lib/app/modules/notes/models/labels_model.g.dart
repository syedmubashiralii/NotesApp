// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labels_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LabelModelAdapter extends TypeAdapter<LabelModel> {
  @override
  final int typeId = 1;

  @override
  LabelModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LabelModel(
      uid: fields[0] as String,
      name: fields[1] as String,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LabelModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

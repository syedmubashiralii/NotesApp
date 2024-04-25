// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderModelAdapter extends TypeAdapter<ReminderModel> {
  @override
  final int typeId = 4;

  @override
  ReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderModel(
      uid: fields[0] as String,
      reminderDescription: fields[1] as String,
      reminderID: fields[2] as String,
      date: fields[3] as DateTime,
      daily: fields[7] as bool,
      did: fields[10] as int,
      weekly: fields[8] as bool,
      wid: fields[11] as int,
      expandedValue: fields[5] as String,
      isExpanded: fields[4] as bool,
      headerValue: fields[6] as String,
      toggle: fields[9] as bool,
      time: fields[12] as TimeOfDay,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.reminderDescription)
      ..writeByte(2)
      ..write(obj.reminderID)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.isExpanded)
      ..writeByte(5)
      ..write(obj.expandedValue)
      ..writeByte(6)
      ..write(obj.headerValue)
      ..writeByte(7)
      ..write(obj.daily)
      ..writeByte(8)
      ..write(obj.weekly)
      ..writeByte(9)
      ..write(obj.toggle)
      ..writeByte(10)
      ..write(obj.did)
      ..writeByte(11)
      ..write(obj.wid)
      ..writeByte(12)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

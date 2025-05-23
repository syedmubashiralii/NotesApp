// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NoteModelAdapter extends TypeAdapter<NoteModel> {
  @override
  final int typeId = 0;

  @override
  NoteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NoteModel(
      document: fields[0] as String,
      searchableDocument: fields[7] as String,
      title: fields[1] as String,
      isArchived: fields[5] as bool,
      isPinned: fields[6] as bool,
      folder: fields[2] as String,
      date: fields[3] as DateTime,
      uid: fields[4] as String,
      labels: (fields[8] as List).cast<String>(),
      user_id: fields[12] as int?,
      id: fields[11] as int?,
      edited: fields[10] as bool,
      encrypted: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NoteModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.document)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.folder)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.uid)
      ..writeByte(5)
      ..write(obj.isArchived)
      ..writeByte(6)
      ..write(obj.isPinned)
      ..writeByte(7)
      ..write(obj.searchableDocument)
      ..writeByte(8)
      ..write(obj.labels)
      ..writeByte(9)
      ..write(obj.encrypted)
      ..writeByte(10)
      ..write(obj.edited)
      ..writeByte(11)
      ..write(obj.id)
      ..writeByte(12)
      ..write(obj.user_id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

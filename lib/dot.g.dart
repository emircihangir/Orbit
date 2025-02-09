// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dot.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DotAdapter extends TypeAdapter<Dot> {
  @override
  final int typeId = 0;

  @override
  Dot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dot(
      id: fields[0] as String,
      title: fields[1] as String?,
      content: fields[2] as String?,
      angle: fields[3] as double?,
      childOf: fields[4] as String?,
      children: (fields[5] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Dot obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.angle)
      ..writeByte(4)
      ..write(obj.childOf)
      ..writeByte(5)
      ..write(obj.children);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DotAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

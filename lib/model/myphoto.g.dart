// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'myphoto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyPhotoAdapter extends TypeAdapter<MyPhoto> {
  @override
  final int typeId = 2;

  @override
  MyPhoto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyPhoto(
      image: fields[1] as File,
      time: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MyPhoto obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyPhotoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkedRepositoryAdapter extends TypeAdapter<BookmarkedRepository> {
  @override
  final int typeId = 0;

  @override
  BookmarkedRepository read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkedRepository(
      owner: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      language: fields[3] as String?,
      stars: fields[4] as int,
      forks: fields[5] as int,
      bookmarkedAt: fields[6] as DateTime,
      tags: (fields[7] as List).cast<String>(),
      avatarUrl: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkedRepository obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.owner)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.language)
      ..writeByte(4)
      ..write(obj.stars)
      ..writeByte(5)
      ..write(obj.forks)
      ..writeByte(6)
      ..write(obj.bookmarkedAt)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.avatarUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkedRepositoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

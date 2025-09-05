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
      repo: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String,
      stars: fields[4] as int,
      forks: fields[5] as int,
      language: fields[6] as String,
      bookmarkedAt: fields[7] as DateTime,
      tags: (fields[8] as List).cast<String>(),
      avatarUrl: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkedRepository obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.owner)
      ..writeByte(1)
      ..write(obj.repo)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.stars)
      ..writeByte(5)
      ..write(obj.forks)
      ..writeByte(6)
      ..write(obj.language)
      ..writeByte(7)
      ..write(obj.bookmarkedAt)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 0;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings()
      ..isDarkMode = fields[0] as bool
      ..isOneSidedChatMode = fields[1] as bool
      ..apikey = fields[2] as String
      ..currentLightThemeIndex = fields[3] as int
      ..currentDarkThemeIndex = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isDarkMode)
      ..writeByte(1)
      ..write(obj.isOneSidedChatMode)
      ..writeByte(2)
      ..write(obj.apikey)
      ..writeByte(3)
      ..write(obj.currentLightThemeIndex)
      ..writeByte(4)
      ..write(obj.currentDarkThemeIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

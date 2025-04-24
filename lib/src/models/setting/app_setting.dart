import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'app_setting.freezed.dart';
part 'app_setting.g.dart';

// 수정된 Hive 어댑터를 등록하기 위한 커스텀 어댑터
class AppSettingAdapter extends TypeAdapter<AppSetting> {
  @override
  final int typeId = 12;

  @override
  AppSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSetting(
      color: fields[0] as String,
      fontSize: fields[1] as int,
      language: fields[2] as String,
      isFirstInstalled: fields[3] as bool,
      autoFocusMode: fields[4] as bool,
      autoBreathingExercise: fields[5] as bool,
      // 새 필드가 없으면 기본값 사용
      whiteNoiseAnimation: fields.containsKey(6) ? fields[6] as bool : true,
    );
  }

  @override
  void write(BinaryWriter writer, AppSetting obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.color)
      ..writeByte(1)
      ..write(obj.fontSize)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.isFirstInstalled)
      ..writeByte(4)
      ..write(obj.autoFocusMode)
      ..writeByte(5)
      ..write(obj.autoBreathingExercise)
      ..writeByte(6)
      ..write(obj.whiteNoiseAnimation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

@freezed
@HiveType(typeId: 12, adapterName: 'AppSettingHiveAdapter')
class AppSetting with _$AppSetting {
  const factory AppSetting({
    @HiveField(0) @Default('227C9D') String color,
    @HiveField(1) @Default(4) int fontSize,
    @HiveField(2) @Default('ko') String language,
    @HiveField(3) @Default(true) bool isFirstInstalled,
    @HiveField(4) @Default(false) bool autoFocusMode,
    @HiveField(5) @Default(true) bool autoBreathingExercise,
    @HiveField(6) @Default(true) bool whiteNoiseAnimation,
  }) = _AppSetting;

  factory AppSetting.fromJson(Map<String, dynamic> json) =>
      _$AppSettingFromJson(json);
}

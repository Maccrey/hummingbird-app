import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'd_day.freezed.dart';
part 'd_day.g.dart';

@freezed
@HiveType(typeId: 10)
class DDay with _$DDay {
  const factory DDay({
    @HiveField(0) String? id,
    @HiveField(1) required String title,
    @HiveField(2) required int targetDate,
    @HiveField(3) required String color,
  }) = _DDay;

  factory DDay.fromJson(Map<String, dynamic> json) => _$DDayFromJson(json);
}
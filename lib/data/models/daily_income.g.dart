// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyIncome _$DailyIncomeFromJson(Map<String, dynamic> json) => DailyIncome(
  id: (json['id'] as num?)?.toInt(),
  date: DateTime.parse(json['date'] as String),
  p1: (json['p1'] as num?)?.toInt() ?? 0,
  p5: (json['p5'] as num?)?.toInt() ?? 0,
  p10: (json['p10'] as num?)?.toInt() ?? 0,
  p20: (json['p20'] as num?)?.toInt() ?? 0,
  p50: (json['p50'] as num?)?.toInt() ?? 0,
  p100: (json['p100'] as num?)?.toInt() ?? 0,
  p200: (json['p200'] as num?)?.toInt() ?? 0,
  p500: (json['p500'] as num?)?.toInt() ?? 0,
  p1000: (json['p1000'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DailyIncomeToJson(DailyIncome instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'p1': instance.p1,
      'p5': instance.p5,
      'p10': instance.p10,
      'p20': instance.p20,
      'p50': instance.p50,
      'p100': instance.p100,
      'p200': instance.p200,
      'p500': instance.p500,
      'p1000': instance.p1000,
    };

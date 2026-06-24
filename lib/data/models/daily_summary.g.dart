// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailySummary _$DailySummaryFromJson(Map<String, dynamic> json) => DailySummary(
  date: DateTime.parse(json['date'] as String),
  grossIncome: (json['grossIncome'] as num).toInt(),
  totalCashOut: (json['totalCashOut'] as num).toInt(),
  dailyFundDeduction: (json['dailyFundDeduction'] as num).toInt(),
  netIncome: (json['netIncome'] as num).toInt(),
);

Map<String, dynamic> _$DailySummaryToJson(DailySummary instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'grossIncome': instance.grossIncome,
      'totalCashOut': instance.totalCashOut,
      'dailyFundDeduction': instance.dailyFundDeduction,
      'netIncome': instance.netIncome,
    };

import 'package:json_annotation/json_annotation.dart';

part 'daily_summary.g.dart';

@JsonSerializable()
class DailySummary {
  final DateTime date;
  final int grossIncome;
  final int totalCashOut;
  final int dailyFundDeduction;
  final int netIncome;

  const DailySummary({
    required this.date,
    required this.grossIncome,
    required this.totalCashOut,
    required this.dailyFundDeduction,
    required this.netIncome,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DailySummaryToJson(this);
}

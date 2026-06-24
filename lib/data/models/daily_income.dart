import 'package:json_annotation/json_annotation.dart';

part 'daily_income.g.dart';

@JsonSerializable()
class DailyIncome {
  final int? id;
  final DateTime date;
  final int p1;
  final int p5;
  final int p10;
  final int p20;
  final int p50;
  final int p100;
  final int p200;
  final int p500;
  final int p1000;

  int get grossIncome {
    return p1 * 1 +
        p5 * 5 +
        p10 * 10 +
        p20 * 20 +
        p50 * 50 +
        p100 * 100 +
        p200 * 200 +
        p500 * 500 +
        p1000 * 1000;
  }

  const DailyIncome({
    this.id,
    required this.date,
    this.p1 = 0,
    this.p5 = 0,
    this.p10 = 0,
    this.p20 = 0,
    this.p50 = 0,
    this.p100 = 0,
    this.p200 = 0,
    this.p500 = 0,
    this.p1000 = 0,
  });

  factory DailyIncome.fromJson(Map<String, dynamic> json) =>
      _$DailyIncomeFromJson(json);

  Map<String, dynamic> toJson() => _$DailyIncomeToJson(this);
}

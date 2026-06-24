import 'package:flutter_test/flutter_test.dart';
import 'package:bb2store_cash_inventory/data/models/daily_summary.dart';

void main() {
  group('DailySummary', () {
    test('creates with required fields', () {
      final summary = DailySummary(
        date: DateTime(2026, 6, 24),
        grossIncome: 5000,
        totalCashOut: 1200,
        dailyFundDeduction: 300,
        netIncome: 3500,
      );
      expect(summary.date, equals(DateTime(2026, 6, 24)));
      expect(summary.grossIncome, equals(5000));
      expect(summary.totalCashOut, equals(1200));
      expect(summary.dailyFundDeduction, equals(300));
      expect(summary.netIncome, equals(3500));
    });

    test('netIncome can be negative', () {
      final summary = DailySummary(
        date: DateTime(2026, 6, 24),
        grossIncome: 500,
        totalCashOut: 1000,
        dailyFundDeduction: 300,
        netIncome: -800,
      );
      expect(summary.netIncome, equals(-800));
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'date': '2026-06-24T00:00:00.000',
        'grossIncome': 10000,
        'totalCashOut': 2000,
        'dailyFundDeduction': 300,
        'netIncome': 7700,
      };
      final summary = DailySummary.fromJson(json);
      expect(summary.grossIncome, equals(10000));
      expect(summary.netIncome, equals(7700));
    });

    test('toJson serializes correctly', () {
      final summary = DailySummary(
        date: DateTime(2026, 6, 24),
        grossIncome: 0,
        totalCashOut: 0,
        dailyFundDeduction: 300,
        netIncome: -300,
      );
      final json = summary.toJson();
      expect(json['netIncome'], equals(-300));
    });
  });
}

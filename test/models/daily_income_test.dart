import 'package:flutter_test/flutter_test.dart';
import 'package:bb2store_cash_inventory/data/models/daily_income.dart';

void main() {
  group('DailyIncome', () {
    test('grossIncome calculates correctly with all denominations', () {
      final income = DailyIncome(
        date: DateTime(2026, 6, 24),
        p1: 5, p5: 3, p10: 2, p20: 4, p50: 1,
        p100: 2, p200: 1, p500: 0, p1000: 1,
      );
      expect(income.grossIncome, equals(5 + 15 + 20 + 80 + 50 + 200 + 200 + 0 + 1000));
    });

    test('grossIncome returns 0 when all quantities are 0', () {
      final income = DailyIncome(
        date: DateTime(2026, 6, 24),
      );
      expect(income.grossIncome, equals(0));
    });

    test('grossIncome with single denomination', () {
      final income = DailyIncome(
        date: DateTime(2026, 6, 24),
        p1000: 3,
      );
      expect(income.grossIncome, equals(3000));
    });

    test('defaults are 0', () {
      final income = DailyIncome(date: DateTime(2026, 6, 24));
      expect(income.p1, equals(0));
      expect(income.p1000, equals(0));
    });

    test('id is nullable', () {
      final income = DailyIncome(date: DateTime(2026, 6, 24));
      expect(income.id, isNull);
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'id': 1,
        'date': '2026-06-24T00:00:00.000',
        'p1': 5, 'p5': 3, 'p10': 2, 'p20': 4, 'p50': 1,
        'p100': 2, 'p200': 1, 'p500': 0, 'p1000': 1,
      };
      final income = DailyIncome.fromJson(json);
      expect(income.id, equals(1));
      expect(income.date, equals(DateTime(2026, 6, 24)));
      expect(income.p100, equals(2));
      expect(income.p1000, equals(1));
    });

    test('toJson serializes correctly', () {
      final income = DailyIncome(
        id: 1,
        date: DateTime(2026, 6, 24),
        p1: 5, p1000: 1,
      );
      final json = income.toJson();
      expect(json['id'], equals(1));
      expect(json['p1'], equals(5));
      expect(json['p1000'], equals(1));
    });

    test('grossIncome with large values does not overflow', () {
      final income = DailyIncome(
        date: DateTime(2026, 6, 24),
        p1000: 100000,
      );
      expect(income.grossIncome, equals(100000000));
    });
  });
}

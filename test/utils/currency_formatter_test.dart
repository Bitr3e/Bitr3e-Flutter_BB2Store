import 'package:flutter_test/flutter_test.dart';
import 'package:bb2store_cash_inventory/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('format returns ₱ symbol and 2 decimal places', () {
      expect(CurrencyFormatter.format(0), equals('₱0.00'));
      expect(CurrencyFormatter.format(100), equals('₱100.00'));
      expect(CurrencyFormatter.format(1234), equals('₱1,234.00'));
      expect(CurrencyFormatter.format(1000000), equals('₱1,000,000.00'));
    });

    test('formatCompact shows K for thousands', () {
      expect(CurrencyFormatter.formatCompact(500), equals('₱500'));
      expect(CurrencyFormatter.formatCompact(1500), equals('₱1.5K'));
      expect(CurrencyFormatter.formatCompact(10000), equals('₱10.0K'));
      expect(CurrencyFormatter.formatCompact(999999), equals('₱1000.0K'));
    });

    test('formatCompact shows M for millions', () {
      expect(CurrencyFormatter.formatCompact(1000000), equals('₱1.0M'));
      expect(CurrencyFormatter.formatCompact(2500000), equals('₱2.5M'));
    });

    test('formatCompact shows plain for small amounts', () {
      expect(CurrencyFormatter.formatCompact(0), equals('₱0'));
      expect(CurrencyFormatter.formatCompact(999), equals('₱999'));
    });
  });
}

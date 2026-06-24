import 'package:flutter_test/flutter_test.dart';
import 'package:bb2store_cash_inventory/data/models/cash_out.dart';

void main() {
  group('CashOutCategory', () {
    test('has correct display names', () {
      expect(CashOutCategory.supplierPayment.displayName, equals('Supplier Payment'));
      expect(CashOutCategory.personalWithdrawal.displayName, equals('Personal Withdrawal'));
      expect(CashOutCategory.storeExpenses.displayName, equals('Store Expenses'));
      expect(CashOutCategory.miscellaneous.displayName, equals('Miscellaneous'));
    });

    test('has 4 values', () {
      expect(CashOutCategory.values.length, equals(4));
    });
  });

  group('CashOut', () {
    test('creates with required fields', () {
      final entry = CashOut(
        date: DateTime(2026, 6, 24),
        amount: 500,
        category: CashOutCategory.storeExpenses,
      );
      expect(entry.date, equals(DateTime(2026, 6, 24)));
      expect(entry.amount, equals(500));
      expect(entry.category, equals(CashOutCategory.storeExpenses));
      expect(entry.description, isNull);
    });

    test('id is nullable', () {
      final entry = CashOut(
        date: DateTime(2026, 6, 24),
        amount: 100,
        category: CashOutCategory.miscellaneous,
      );
      expect(entry.id, isNull);
    });

    test('accepts optional description', () {
      final entry = CashOut(
        date: DateTime(2026, 6, 24),
        amount: 200,
        category: CashOutCategory.supplierPayment,
        description: 'Payment for goods',
      );
      expect(entry.description, equals('Payment for goods'));
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'id': 1,
        'date': '2026-06-24T00:00:00.000',
        'amount': 150,
        'category': 'storeExpenses',
        'description': 'Office supplies',
      };
      final entry = CashOut.fromJson(json);
      expect(entry.id, equals(1));
      expect(entry.amount, equals(150));
      expect(entry.category, equals(CashOutCategory.storeExpenses));
      expect(entry.description, equals('Office supplies'));
    });

    test('toJson serializes correctly', () {
      final entry = CashOut(
        id: 1,
        date: DateTime(2026, 6, 24),
        amount: 1000,
        category: CashOutCategory.personalWithdrawal,
      );
      final json = entry.toJson();
      expect(json['amount'], equals(1000));
      expect(json['category'], equals('personalWithdrawal'));
    });
  });
}

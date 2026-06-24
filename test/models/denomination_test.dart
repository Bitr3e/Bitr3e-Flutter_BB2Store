import 'package:flutter_test/flutter_test.dart';
import 'package:bb2store_cash_inventory/data/models/denomination.dart';

void main() {
  group('Denomination', () {
    test('creates with required value', () {
      final d = Denomination(value: 100);
      expect(d.value, equals(100));
      expect(d.quantity, equals(0));
    });

    test('accepts optional quantity', () {
      final d = Denomination(value: 50, quantity: 3);
      expect(d.quantity, equals(3));
    });

    test('subtotal is value * quantity', () {
      expect(Denomination(value: 100, quantity: 5).subtotal, equals(500));
      expect(Denomination(value: 1000, quantity: 0).subtotal, equals(0));
      expect(Denomination(value: 1, quantity: 999).subtotal, equals(999));
    });

    test('negative values allowed for edge cases', () {
      final d = Denomination(value: 100, quantity: -1);
      expect(d.subtotal, equals(-100));
    });

    test('fromJson deserializes correctly', () {
      final json = {'value': 200, 'quantity': 2};
      final d = Denomination.fromJson(json);
      expect(d.value, equals(200));
      expect(d.quantity, equals(2));
    });

    test('toJson serializes correctly', () {
      final d = Denomination(value: 500, quantity: 1);
      final json = d.toJson();
      expect(json['value'], equals(500));
      expect(json['quantity'], equals(1));
    });
  });
}

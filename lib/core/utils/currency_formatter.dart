import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final _format = NumberFormat.currency(
    symbol: '₱',
    decimalDigits: 2,
    locale: 'en_PH',
  );

  static String format(int amount) {
    return _format.format(amount);
  }

  static String formatCompact(int amount) {
    if (amount >= 1000000) {
      return '₱${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '₱${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '₱$amount';
  }
}

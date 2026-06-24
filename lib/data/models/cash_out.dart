import 'package:json_annotation/json_annotation.dart';

part 'cash_out.g.dart';

enum CashOutCategory {
  supplierPayment('Supplier Payment'),
  personalWithdrawal('Personal Withdrawal'),
  storeExpenses('Store Expenses'),
  miscellaneous('Miscellaneous');

  final String displayName;
  const CashOutCategory(this.displayName);
}

@JsonSerializable()
class CashOut {
  final int? id;
  final DateTime date;
  final int amount;
  final CashOutCategory category;
  final String? description;

  const CashOut({
    this.id,
    required this.date,
    required this.amount,
    required this.category,
    this.description,
  });

  factory CashOut.fromJson(Map<String, dynamic> json) =>
      _$CashOutFromJson(json);

  Map<String, dynamic> toJson() => _$CashOutToJson(this);
}

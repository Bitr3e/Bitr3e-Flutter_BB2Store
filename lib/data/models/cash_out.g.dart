// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CashOut _$CashOutFromJson(Map<String, dynamic> json) => CashOut(
  id: (json['id'] as num?)?.toInt(),
  date: DateTime.parse(json['date'] as String),
  amount: (json['amount'] as num).toInt(),
  category: $enumDecode(_$CashOutCategoryEnumMap, json['category']),
  description: json['description'] as String?,
);

Map<String, dynamic> _$CashOutToJson(CashOut instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date.toIso8601String(),
  'amount': instance.amount,
  'category': _$CashOutCategoryEnumMap[instance.category]!,
  'description': instance.description,
};

const _$CashOutCategoryEnumMap = {
  CashOutCategory.supplierPayment: 'supplierPayment',
  CashOutCategory.personalWithdrawal: 'personalWithdrawal',
  CashOutCategory.storeExpenses: 'storeExpenses',
  CashOutCategory.miscellaneous: 'miscellaneous',
};

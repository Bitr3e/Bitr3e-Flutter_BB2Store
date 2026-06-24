// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'denomination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Denomination _$DenominationFromJson(Map<String, dynamic> json) => Denomination(
  value: (json['value'] as num).toInt(),
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DenominationToJson(Denomination instance) =>
    <String, dynamic>{'value': instance.value, 'quantity': instance.quantity};

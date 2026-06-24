import 'package:json_annotation/json_annotation.dart';

part 'denomination.g.dart';

@JsonSerializable()
class Denomination {
  final int value;
  final int quantity;

  int get subtotal => value * quantity;

  const Denomination({
    required this.value,
    this.quantity = 0,
  });

  factory Denomination.fromJson(Map<String, dynamic> json) =>
      _$DenominationFromJson(json);

  Map<String, dynamic> toJson() => _$DenominationToJson(this);
}

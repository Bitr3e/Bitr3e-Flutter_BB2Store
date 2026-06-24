import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/currency_formatter.dart';

class DenominationInputRow extends StatelessWidget {
  final int denomination;
  final int quantity;
  final ValueChanged<int> onChanged;

  const DenominationInputRow({
    super.key,
    required this.denomination,
    required this.quantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtotal = denomination * quantity;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '₱${denomination.toString()}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  width: 100,
                  child: TextField(
                    key: ValueKey('denom_$denomination'),
                    controller: TextEditingController(
                      text: quantity > 0 ? quantity.toString() : '',
                    )
                      ..selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: quantity > 0
                              ? quantity.toString().length
                              : 0,
                        ),
                      ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '0',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value) ?? 0;
                      onChanged(parsed);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 90,
                child: Text(
                  CurrencyFormatter.format(subtotal),
                  textAlign: TextAlign.right,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

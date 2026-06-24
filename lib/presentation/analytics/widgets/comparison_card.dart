import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';

class ComparisonCard extends StatelessWidget {
  final String title;
  final String currentLabel;
  final String previousLabel;
  final int current;
  final int previous;
  final int difference;
  final double percentageChange;

  const ComparisonCard({
    super.key,
    required this.title,
    required this.currentLabel,
    required this.previousLabel,
    required this.current,
    required this.previous,
    required this.difference,
    required this.percentageChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUp = difference > 0;
    final isDown = difference < 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _side(
                    context,
                    currentLabel,
                    current,
                    true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    isUp
                        ? Icons.trending_up
                        : isDown
                            ? Icons.trending_down
                            : Icons.remove,
                    color: isUp
                        ? Colors.green
                        : isDown
                            ? theme.colorScheme.error
                            : Colors.grey,
                    size: 28,
                  ),
                ),
                Expanded(
                  child: _side(
                    context,
                    previousLabel,
                    previous,
                    false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                isUp
                    ? '▲ ${CurrencyFormatter.format(difference.abs())} (+${percentageChange.toStringAsFixed(1)}%)'
                    : isDown
                        ? '▼ ${CurrencyFormatter.format(difference.abs())} (${percentageChange.toStringAsFixed(1)}%)'
                        : 'No change',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isUp
                      ? Colors.green
                      : isDown
                          ? theme.colorScheme.error
                          : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _side(
    BuildContext context,
    String label,
    int amount,
    bool isCurrent,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(amount),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isCurrent
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

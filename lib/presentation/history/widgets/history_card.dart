import 'package:flutter/material.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../history/providers/history_provider.dart';

class HistoryCard extends StatelessWidget {
  final HistoryGroup group;

  const HistoryCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (group.subtitle.isNotEmpty)
                        Text(
                          group.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  CurrencyFormatter.format(group.netIncome),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: group.netIncome >= 0
                        ? Colors.green
                        : theme.colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStat(
                  context,
                  'Gross',
                  CurrencyFormatter.format(group.totalGross),
                  Colors.green,
                ),
                const SizedBox(width: 16),
                _buildStat(
                  context,
                  'Cash-Out',
                  CurrencyFormatter.format(group.totalCashOut),
                  theme.colorScheme.error,
                ),
                const SizedBox(width: 16),
                _buildStat(
                  context,
                  'Days',
                  '${group.incomeRecords.length}',
                  Colors.blueGrey,
                ),
                const Spacer(),
                if (group.averageDaily > 0)
                  _buildStat(
                    context,
                    'Avg/Day',
                    CurrencyFormatter.format(group.averageDaily.round()),
                    Colors.indigo,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
      ],
    );
  }
}

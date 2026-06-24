import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import 'providers/net_income_provider.dart';

class NetIncomeScreen extends ConsumerWidget {
  const NetIncomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final netIncomeAsync = ref.watch(netIncomeProvider);
    final notifier = ref.read(netIncomeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Net Income Calculation'),
        centerTitle: true,
      ),
      body: netIncomeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => _buildContent(context, data, notifier),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    NetIncomeData data,
    NetIncomeNotifier notifier,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateHeader(context, data, notifier),
          const SizedBox(height: 20),
          Text(
            'Formula',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildFormulaCard(context, data),
          const SizedBox(height: 20),
          if (!data.hasData)
            _buildNoData(context)
          else ...[
            Text(
              'Denomination Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDenominationBreakdown(context, data),
            const SizedBox(height: 20),
            if (data.cashOutEntries.isNotEmpty) ...[
              Text(
                'Cash-Out Entries',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildCashOutList(context, data),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildDateHeader(
    BuildContext context,
    NetIncomeData data,
    NetIncomeNotifier notifier,
  ) {
    final theme = Theme.of(context);
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return Center(
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: data.date,
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            notifier.selectDate(picked);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${months[data.date.month - 1]} ${data.date.day}, ${data.date.year}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulaCard(BuildContext context, NetIncomeData data) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _formulaRow(
              context,
              'Gross Income',
              CurrencyFormatter.format(data.grossIncome),
              Colors.green,
              isTotal: true,
            ),
            const Divider(),
            _formulaRow(
              context,
              'Total Cash-Out',
              '- ${CurrencyFormatter.format(data.totalCashOut)}',
              theme.colorScheme.error,
            ),
            _formulaRow(
              context,
              'Daily Fund Deduction',
              '- ₱${AppConstants.dailyFundDeduction}.00',
              Colors.orange,
            ),
            const Divider(thickness: 2),
            _formulaRow(
              context,
              'Net Income',
              CurrencyFormatter.format(data.netIncome),
              data.netIncome >= 0 ? Colors.green : theme.colorScheme.error,
              isTotal: true,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _formulaRow(
    BuildContext context,
    String label,
    String value,
    Color color, {
    bool isTotal = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                  color: color,
                  fontSize: isTotal ? 18 : 14,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDenominationBreakdown(
    BuildContext context,
    NetIncomeData data,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: data.denominations
              .where((d) => d.quantity > 0)
              .map((d) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '₱${d.value}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text('× ${d.quantity}'),
                        const Spacer(),
                        Text(
                          CurrencyFormatter.format(d.subtotal),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildCashOutList(BuildContext context, NetIncomeData data) {
    return Card(
      child: Column(
        children: data.cashOutEntries.map((entry) {
          return ListTile(
            dense: true,
            title: Text(entry.description ?? 'Cash-Out'),
            trailing: Text(
              CurrencyFormatter.format(entry.amount),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNoData(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              'No income record for this date',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

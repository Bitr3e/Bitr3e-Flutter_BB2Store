import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/currency_formatter.dart';
import 'providers/history_provider.dart';
import 'widgets/history_card.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildChips(context, state, notifier),
          _buildOverallTotal(context, state),
          const Divider(height: 1),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.groups.isEmpty
                    ? _buildEmptyState(context)
                    : _buildList(state),
          ),
        ],
      ),
    );
  }

  Widget _buildChips(
    BuildContext context,
    HistoryState state,
    HistoryNotifier notifier,
  ) {
    const views = [
      ('Daily', HistoryViewType.daily),
      ('Weekly', HistoryViewType.weekly),
      ('Monthly', HistoryViewType.monthly),
      ('Yearly', HistoryViewType.yearly),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: views.map((v) {
            final isSelected = state.viewType == v.$2;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(v.$1),
                selected: isSelected,
                onSelected: (_) => notifier.setViewType(v.$2),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOverallTotal(BuildContext context, HistoryState state) {
    final totalGross = state.groups.fold(0, (sum, g) => sum + g.totalGross);
    final totalCashOut = state.groups.fold(0, (sum, g) => sum + g.totalCashOut);
    final totalNet = state.groups.fold(0, (sum, g) => sum + g.netIncome);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _totalStat(context, 'Gross', CurrencyFormatter.format(totalGross),
              Colors.green),
          const SizedBox(width: 12),
          _totalStat(context, 'Cash-Out',
              CurrencyFormatter.format(totalCashOut), theme.colorScheme.error),
          const SizedBox(width: 12),
          _totalStat(context, 'Net', CurrencyFormatter.format(totalNet),
              totalNet >= 0 ? Colors.green : theme.colorScheme.error),
        ],
      ),
    );
  }

  Widget _totalStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    )),
            Text(value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    )),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No records found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(HistoryState state) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: state.groups.length,
      itemBuilder: (context, index) {
        return HistoryCard(group: state.groups[index]);
      },
    );
  }
}

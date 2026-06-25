import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;

import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/database/app_database.dart';
import '../../data/models/cash_out.dart';
import '../../domain/providers/repository_providers.dart';
import 'widgets/cash_out_form_dialog.dart';
import '../history/providers/history_provider.dart';
import 'providers/income_recording_provider.dart';
import 'widgets/denomination_input_row.dart';

class IncomeRecordingScreen extends ConsumerWidget {
  const IncomeRecordingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(incomeRecordingProvider);
    final notifier = ref.read(incomeRecordingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Daily Income'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (state.errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.errorContainer,
              child: Text(
                state.errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ),
            ),
          if (state.isLocked)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.lock,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Today's record has already been saved",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: state.isLoaded
                ? ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    children: [
                      ...AppConstants.denominations.map(
                        (d) => DenominationInputRow(
                          key: ValueKey('row_$d'),
                          denomination: d,
                          quantity: state.quantities[d] ?? 0,
                          onChanged: (value) =>
                              notifier.updateQuantity(d, value),
                          enabled: !state.isLocked,
                        ),
                      ),
                      const Divider(height: 24),
                      _buildCashOutSection(context, ref, state, notifier),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          _buildBottomBar(context, ref, state, notifier),
        ],
      ),
    );
  }

  Widget _buildCashOutSection(
    BuildContext context,
    WidgetRef ref,
    IncomeRecordingState state,
    IncomeRecordingNotifier notifier,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Cash-Out",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
            if (!state.isLocked)
              TextButton.icon(
                onPressed: () => _addCashOut(context, ref, notifier),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
              ),
          ],
        ),
        if (state.todayCashOuts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No cash-out entries for today',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          )
        else
          ...state.todayCashOuts.map(
            (entry) => _cashOutItem(context, ref, entry, locked: state.isLocked),
          ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Cash-Out:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              CurrencyFormatter.format(state.totalCashOut),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _cashOutItem(
    BuildContext context,
    WidgetRef ref,
    CashOutEntry entry, {
    bool locked = false,
  }) {
    final category = CashOutCategory.values.firstWhere(
      (c) => c.name == entry.category,
      orElse: () => CashOutCategory.miscellaneous,
    );
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        _categoryIcon(category),
        size: 20,
        color: _categoryColor(category),
      ),
      title: Text(
        category.displayName,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            CurrencyFormatter.format(entry.amount),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
          if (!locked) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => _deleteCashOut(context, ref, entry),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _deleteCashOut(
    BuildContext context,
    WidgetRef ref,
    CashOutEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cash-Out'),
        content: Text(
          'Delete cash-out of ${CurrencyFormatter.format(entry.amount)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final cashOutRepo = ref.read(cashOutRepositoryProvider);
    await cashOutRepo.deleteCashOut(entry.id);
    await ref.read(incomeRecordingProvider.notifier).refresh();

    ref.read(historyProvider.notifier).refresh();
  }

  Future<void> _addCashOut(
    BuildContext context,
    WidgetRef ref,
    IncomeRecordingNotifier notifier,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CashOutFormDialog(),
    );

    if (result == null || !context.mounted) return;

    final cashOutRepo = ref.read(cashOutRepositoryProvider);
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    final companion = CashOutEntriesCompanion(
      date: Value(dateOnly),
      amount: Value(result['amount'] as int),
      category: Value((result['category'] as CashOutCategory).name),
      description: Value(result['description'] as String?),
    );

    await cashOutRepo.addCashOut(companion);
    await notifier.refresh();

    ref.read(historyProvider.notifier).refresh();
  }

  IconData _categoryIcon(CashOutCategory category) {
    switch (category) {
      case CashOutCategory.supplierPayment:
        return Icons.inventory;
      case CashOutCategory.personalWithdrawal:
        return Icons.person;
      case CashOutCategory.storeExpenses:
        return Icons.store;
      case CashOutCategory.miscellaneous:
        return Icons.more_horiz;
    }
  }

  Color _categoryColor(CashOutCategory category) {
    switch (category) {
      case CashOutCategory.supplierPayment:
        return Colors.orange;
      case CashOutCategory.personalWithdrawal:
        return Colors.purple;
      case CashOutCategory.storeExpenses:
        return Colors.blue;
      case CashOutCategory.miscellaneous:
        return Colors.grey;
    }
  }

  Widget _buildBottomBar(
    BuildContext context,
    WidgetRef ref,
    IncomeRecordingState state,
    IncomeRecordingNotifier notifier,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gross Income:',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                CurrencyFormatter.format(state.grossIncome),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cash-Out:',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '+${CurrencyFormatter.format(state.totalCashOut)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Fund:',
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '-${CurrencyFormatter.format(state.dailyFundAmount)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Net Income:',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                CurrencyFormatter.format(state.netIncome),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: state.netIncome >= 0
                      ? Colors.green
                      : theme.colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (state.isLocked)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 20,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Record Saved for Today',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: state.isSaving ? null : () => _save(context, ref),
                icon: state.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(state.isSaving ? 'Saving...' : 'Save Record'),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(incomeRecordingProvider.notifier);
    final success = await notifier.save();
    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Income record saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

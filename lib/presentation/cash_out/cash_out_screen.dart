import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/currency_formatter.dart';
import '../../data/database/app_database.dart';
import '../../data/models/cash_out.dart';
import 'providers/cash_out_provider.dart';
import 'widgets/cash_out_form_dialog.dart';
import 'widgets/cash_out_tile.dart';

class CashOutScreen extends ConsumerWidget {
  const CashOutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cashOutProvider);
    final notifier = ref.read(cashOutProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cash-Out'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildDateHeader(context, state, notifier),
          _buildTotalBar(context, state),
          const Divider(height: 1),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.entries.isEmpty
                    ? _buildEmptyState(context)
                    : _buildList(context, ref, state),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDateHeader(
    BuildContext context,
    CashOutState state,
    CashOutNotifier notifier,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: () async {
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: state.selectedDate,
            firstDate: DateTime(2020),
            lastDate: DateTime(now.year + 1),
          );
          if (picked != null) {
            notifier.selectDate(picked);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(width: 8),
            Text(
              _formatDate(state.selectedDate),
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

  Widget _buildTotalBar(BuildContext context, CashOutState state) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Cash-Out:', style: theme.textTheme.titleMedium),
          Text(
            CurrencyFormatter.format(state.totalCashOut),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.money_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No cash-out entries',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add a cash-out entry',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    CashOutState state,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.entries.length,
      itemBuilder: (context, index) {
        final entry = state.entries[index];
        return CashOutTile(
          key: ValueKey(entry.id),
          entry: entry,
          onEdit: () => _showEditDialog(context, ref, entry),
          onDelete: () => _confirmDelete(context, ref, entry),
        );
      },
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CashOutFormDialog(),
    );

    if (result == null || !context.mounted) return;

    ref.read(cashOutProvider.notifier).addEntry(
          amount: result['amount'] as int,
          category: result['category'] as CashOutCategory,
          description: result['description'] as String?,
        );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    CashOutEntry entry,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CashOutFormDialog(existingEntry: entry),
    );

    if (result == null || !context.mounted) return;

    ref.read(cashOutProvider.notifier).updateEntry(
          id: entry.id,
          amount: result['amount'] as int,
          category: result['category'] as CashOutCategory,
          description: result['description'] as String?,
        );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    CashOutEntry entry,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: Text(
          'Delete ${_parseCategory(entry.category).displayName} (${CurrencyFormatter.format(entry.amount)})?',
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

    if (confirmed == true && context.mounted) {
      ref.read(cashOutProvider.notifier).deleteEntry(entry.id);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  CashOutCategory _parseCategory(String value) {
    return CashOutCategory.values.firstWhere(
      (c) => c.name == value,
      orElse: () => CashOutCategory.miscellaneous,
    );
  }
}

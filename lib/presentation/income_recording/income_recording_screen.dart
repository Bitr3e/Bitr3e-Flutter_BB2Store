import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
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
          Expanded(
            child: state.isLoaded
                ? ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ...AppConstants.denominations.map(
                        (d) => DenominationInputRow(
                          key: ValueKey('row_$d'),
                          denomination: d,
                          quantity: state.quantities[d] ?? 0,
                          onChanged: (value) =>
                              notifier.updateQuantity(d, value),
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          _buildBottomBar(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: state.isSaving ? null : () => _save(context, notifier),
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

  Future<void> _save(
    BuildContext context,
    IncomeRecordingNotifier notifier,
  ) async {
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader(title: 'Daily Fund'),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text('Daily Fund Amount'),
            subtitle: Text('₱${settings.dailyFundAmount}'),
            trailing: const Icon(Icons.edit),
            onTap: () => _editDailyFund(context, ref, settings.dailyFundAmount),
          ),
          const Divider(),
          const _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Theme Mode'),
            subtitle: Text(_themeLabel(settings.themeMode)),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () => _selectThemeMode(context, ref, settings.themeMode),
          ),
          const Divider(),
          const _SectionHeader(title: 'Currency'),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Currency Symbol'),
            subtitle: Text(settings.currencySymbol),
            trailing: const Icon(Icons.edit),
            onTap: () => _editCurrencySymbol(
              context,
              ref,
              settings.currencySymbol,
            ),
          ),
          const Divider(),
          const _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version'),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  String _themeLabel(String mode) {
    switch (mode) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System';
    }
  }

  Future<void> _editDailyFund(
    BuildContext context,
    WidgetRef ref,
    int current,
  ) async {
    final controller = TextEditingController(text: current.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Daily Fund Amount'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₱ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value >= 0) {
                Navigator.pop(ctx, value);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      ref.read(settingsNotifierProvider.notifier).setDailyFundAmount(result);
    }
  }

  Future<void> _selectThemeMode(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Theme Mode'),
        children: ['system', 'light', 'dark'].map((mode) {
          final selected = mode == current;
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, mode),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: selected
                      ? Theme.of(ctx).colorScheme.primary
                      : null,
                ),
                const SizedBox(width: 12),
                Text(_themeLabel(mode)),
              ],
            ),
          );
        }).toList(),
      ),
    );
    if (result != null) {
      ref.read(settingsNotifierProvider.notifier).setThemeMode(result);
    }
  }

  Future<void> _editCurrencySymbol(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final controller = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Currency Symbol'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Symbol',
            hintText: '₱',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) Navigator.pop(ctx, text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      ref.read(settingsNotifierProvider.notifier).setCurrencySymbol(result);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

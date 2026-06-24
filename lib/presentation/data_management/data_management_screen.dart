import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/data_management_provider.dart';
import 'record_management_screen.dart';

class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({super.key});

  @override
  ConsumerState<DataManagementScreen> createState() =>
      _DataManagementScreenState();
}

class _DataManagementScreenState
    extends ConsumerState<DataManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dataManagementProvider.notifier).loadBackups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dataManagementProvider);
    final notifier = ref.read(dataManagementProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (state.message != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: state.message!.contains('fail')
                  ? theme.colorScheme.errorContainer
                  : Colors.green.shade100,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      state.message!,
                      style: TextStyle(
                        color: state.message!.contains('fail')
                            ? theme.colorScheme.onErrorContainer
                            : Colors.green.shade900,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: notifier.clearMessage,
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionHeader(context, 'Export & Backup'),
                const SizedBox(height: 8),
                _actionCard(
                  context,
                  icon: Icons.file_download,
                  title: 'Export All Data to CSV',
                  subtitle: 'Save income & cash-out records as CSV files',
                  isLoading: state.isExporting,
                  onTap: state.isExporting ? null : notifier.exportAll,
                ),
                const SizedBox(height: 24),
                _sectionHeader(context, 'Import & Restore'),
                const SizedBox(height: 8),
                if (state.isLoadingBackups)
                  const Center(child: CircularProgressIndicator())
                else if (state.backupFiles.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No backup files found.\nExport data first.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                  )
                else
                  ...state.backupFiles.map(
                    (file) => _backupFileTile(context, file, notifier),
                  ),
                const SizedBox(height: 24),
                _sectionHeader(context, 'Record Management'),
                const SizedBox(height: 8),
                _actionCard(
                  context,
                  icon: Icons.edit_note,
                  title: 'Manage Historical Records',
                  subtitle: 'View, edit, or delete past entries',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RecordManagementScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 28, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(subtitle,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backupFileTile(
    BuildContext context,
    String filePath,
    DataManagementNotifier notifier,
  ) {
    final fileName = filePath.split('\\').last.split('/').last;
    final file = File(filePath);
    final size = file.lengthSync();
    final sizeStr = size > 1024
        ? '${(size / 1024).toStringAsFixed(1)} KB'
        : '$size B';

    return Card(
      child: ListTile(
        leading: const Icon(Icons.description),
        title: Text(fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(sizeStr),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'import') {
              notifier.importFromFile(filePath);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'import', child: Text('Import')),
          ],
        ),
      ),
    );
  }
}

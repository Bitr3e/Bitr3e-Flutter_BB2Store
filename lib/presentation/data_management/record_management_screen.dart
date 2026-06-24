import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/currency_formatter.dart';
import '../../data/database/app_database.dart';
import '../../domain/providers/repository_providers.dart';
import '../net_income/net_income_screen.dart';

class RecordManagementScreen extends ConsumerWidget {
  const RecordManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomeRepo = ref.read(incomeRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historical Records'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DailyIncomeRecord>>(
        future: incomeRepo.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No historical records',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final gross = _gross(record);
              final months = [
                'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
              ];
              final dateStr =
                  '${months[record.date.month - 1]} ${record.date.day}, ${record.date.year}';

              return Card(
                child: ListTile(
                  title: Text(dateStr),
                  subtitle: Text('Gross: ${CurrencyFormatter.format(gross)}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'view') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NetIncomeScreen(),
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Record'),
                            content: Text(
                              'Delete income record for $dateStr (${CurrencyFormatter.format(gross)})?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                style: FilledButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.error,
                                ),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true && context.mounted) {
                          await incomeRepo.deleteRecord(record.id);
                          (context as Element).markNeedsBuild();
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'view', child: Text('View Details')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  int _gross(DailyIncomeRecord r) {
    return r.p1 * 1 +
        r.p5 * 5 +
        r.p10 * 10 +
        r.p20 * 20 +
        r.p50 * 50 +
        r.p100 * 100 +
        r.p200 * 200 +
        r.p500 * 500 +
        r.p1000 * 1000;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/graph_data_provider.dart';
import 'widgets/comparison_bar_chart.dart';
import 'widgets/daily_line_chart.dart';
import 'widgets/monthly_bar_chart.dart';
import 'widgets/weekly_bar_chart.dart';
import 'widgets/yearly_line_chart.dart';

class GraphsScreen extends ConsumerWidget {
  const GraphsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphAsync = ref.watch(graphDataProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphs & Visualizations'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(graphDataProvider.notifier).refresh(),
          ),
        ],
      ),
      body: graphAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          if (!data.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bar_chart_outlined,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No data to visualize yet',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _section(
                  context,
                  ComparisonBarChart(
                    grossIncome: data.dailyPoints.isNotEmpty
                        ? data.dailyPoints.last.gross
                        : 0,
                    cashOut: _totalCashOut(data),
                  ),
                ),
                const SizedBox(height: 24),
                _section(context, DailyLineChart(data: data.dailyPoints)),
                const SizedBox(height: 24),
                _section(context, WeeklyBarChart(data: data.weeklyPoints)),
                const SizedBox(height: 24),
                _section(context, MonthlyBarChart(data: data.monthlyPoints)),
                const SizedBox(height: 24),
                _section(context, YearlyLineChart(data: data.yearlyPoints)),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  int _totalCashOut(GraphData data) {
    var total = 0;
    for (final m in data.monthlyPoints) {
      total += m.cashOut;
    }
    return total;
  }

  Widget _section(BuildContext context, Widget chart) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: chart,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/currency_formatter.dart';
import 'providers/analytics_provider.dart';
import 'widgets/comparison_card.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(analyticsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: analyticsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) {
          if (!data.hasData) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.analytics_outlined,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No data yet. Start recording income!',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(color: Colors.grey)),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Income Statistics',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildStatsGrid(context, data),
                const SizedBox(height: 24),
                Text('Comparisons',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildComparisons(context, data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, AnalyticsData data) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: _statCard(context, 'Highest Day', data.highestIncome,
                  Icons.emoji_events, Colors.amber),
            ),
            SizedBox(
              width: cardWidth,
              child: _statCard(context, 'Lowest Day', data.lowestIncome,
                  Icons.arrow_downward, Colors.blueGrey),
            ),
            SizedBox(
              width: cardWidth,
              child: _statCardDouble(
                context,
                'Avg Daily',
                CurrencyFormatter.format(data.averageDailyIncome.round()),
                Icons.trending_up,
                Colors.green,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: _statCardDouble(
                context,
                'Avg Monthly',
                CurrencyFormatter.format(data.averageMonthlyIncome.round()),
                Icons.calendar_month,
                Colors.indigo,
              ),
            ),
            SizedBox(
              width: cardWidth * 2 + 12,
              child: _statCardDouble(
                context,
                'Year Total',
                CurrencyFormatter.format(data.yearTotalIncome),
                Icons.calendar_today,
                Colors.deepOrange,
                isLarge: true,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(
    BuildContext context,
    String title,
    int amount,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(title,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            Text(CurrencyFormatter.format(amount),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }

  Widget _statCardDouble(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color, {
    bool isLarge = false,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(title,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            Text(value,
                style: (isLarge
                        ? theme.textTheme.headlineMedium
                        : theme.textTheme.headlineSmall)
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisons(BuildContext context, AnalyticsData data) {
    return Column(
      children: [
        ComparisonCard(
          title: 'Today vs Yesterday',
          currentLabel: 'Today',
          previousLabel: 'Yesterday',
          current: data.todayVsYesterday.current,
          previous: data.todayVsYesterday.previous,
          difference: data.todayVsYesterday.difference,
          percentageChange: data.todayVsYesterday.percentageChange,
        ),
        const SizedBox(height: 12),
        ComparisonCard(
          title: 'This Week vs Last Week',
          currentLabel: 'This Week',
          previousLabel: 'Last Week',
          current: data.thisWeekVsLastWeek.current,
          previous: data.thisWeekVsLastWeek.previous,
          difference: data.thisWeekVsLastWeek.difference,
          percentageChange: data.thisWeekVsLastWeek.percentageChange,
        ),
        const SizedBox(height: 12),
        ComparisonCard(
          title: 'This Month vs Last Month',
          currentLabel: 'This Month',
          previousLabel: 'Last Month',
          current: data.thisMonthVsLastMonth.current,
          previous: data.thisMonthVsLastMonth.previous,
          difference: data.thisMonthVsLastMonth.difference,
          percentageChange: data.thisMonthVsLastMonth.percentageChange,
        ),
      ],
    );
  }
}

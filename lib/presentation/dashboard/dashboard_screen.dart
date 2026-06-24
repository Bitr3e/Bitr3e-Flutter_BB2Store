import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/providers/dashboard_provider.dart';
import '../analytics/analytics_screen.dart';
import '../graphs/graphs_screen.dart';
import '../net_income/net_income_screen.dart';
import 'models/dashboard_data.dart';
import 'widgets/stat_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(dashboardProvider.notifier).refresh(),
          ),
        ],
      ),
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => _DashboardContent(data: data),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardData data;

  const _DashboardContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // refresh handled by the app bar button for now
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildTodaySummary(context),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Analytics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AnalyticsScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildAnalyticsGrid(context),
            const SizedBox(height: 24),
            Text(
              'Period Totals',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildPeriodGrid(context),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const GraphsScreen(),
                  ),
                ),
                icon: const Icon(Icons.bar_chart),
                label: const Text('View Graphs & Charts'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySummary(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'Gross Income',
                amount: data.todayGrossIncome,
                icon: Icons.trending_up,
                iconColor: Colors.green,
                backgroundColor: data.hasData ? null : Colors.grey.withValues(alpha: 0.1),
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'Cash-Out',
                amount: data.todayCashOut,
                icon: Icons.money_off,
                iconColor: AppTheme.accentColor,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'Daily Fund',
                amount: data.dailyFundDeduction,
                icon: Icons.account_balance,
                iconColor: Colors.orange,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'Net Income',
                amount: data.todayNetIncome,
                icon: Icons.savings,
                iconColor: data.todayNetIncome >= 0 ? Colors.green : Colors.red,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NetIncomeScreen(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalyticsGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'Highest Income',
                amount: data.highestIncome ?? 0,
                icon: Icons.emoji_events,
                iconColor: Colors.amber,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'Lowest Income',
                amount: data.lowestIncome ?? 0,
                icon: Icons.arrow_downward,
                iconColor: Colors.blueGrey,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'Yesterday',
                amount: data.yesterdayIncome ?? 0,
                icon: Icons.history,
                iconColor: Colors.purple,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'Today\'s Net',
                amount: data.todayNetIncome,
                icon: Icons.account_balance_wallet,
                iconColor: data.todayNetIncome >= 0 ? Colors.teal : Colors.red,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NetIncomeScreen(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPeriodGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'This Week',
                amount: data.weekIncome,
                icon: Icons.calendar_view_week,
                iconColor: Colors.indigo,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'This Month',
                amount: data.monthIncome,
                icon: Icons.calendar_month,
                iconColor: Colors.cyan,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: StatCard(
                title: 'This Year',
                amount: data.yearIncome,
                icon: Icons.calendar_today,
                iconColor: Colors.deepOrange,
              ),
            ),
          ],
        );
      },
    );
  }
}

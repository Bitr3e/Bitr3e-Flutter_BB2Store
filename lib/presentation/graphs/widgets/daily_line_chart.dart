import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/graph_data_provider.dart';

class DailyLineChart extends StatelessWidget {
  final List<DailyChartPoint> data;

  const DailyLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (data.isEmpty) {
      return const Center(child: Text('No daily data'));
    }

    final display = data.length > 30 ? data.sublist(data.length - 30) : data;
    final maxY = display.fold<double>(0, (m, p) => m > p.net ? m : p.net.toDouble());
    final minY = display.fold<double>(0, (m, p) => m < p.net ? m : p.net.toDouble());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Net Income Trend',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _niceInterval(maxY, minY),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 48,
                    getTitlesWidget: (value, meta) {
                      return Text('₱${value.toInt()}',
                          style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    interval: (display.length / 5).ceilToDouble(),
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= display.length) return const SizedBox();
                      final months = [
                        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                      ];
                      final d = display[idx].date;
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${months[d.month - 1]} ${d.day}',
                            style: const TextStyle(fontSize: 9)),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: display.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value.net.toDouble());
                  }).toList(),
                  isCurved: true,
                  color: theme.colorScheme.primary,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  ),
                ),
              ],
              minY: minY > 0 ? 0 : minY,
              maxY: maxY * 1.1,
            ),
          ),
        ),
      ],
    );
  }

  double _niceInterval(double max, double min) {
    final range = (max - min).abs();
    if (range < 500) return 100;
    if (range < 2000) return 500;
    if (range < 5000) return 1000;
    return (range / 5).ceilToDouble();
  }
}

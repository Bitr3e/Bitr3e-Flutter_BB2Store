import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/graph_data_provider.dart';

class YearlyLineChart extends StatelessWidget {
  final List<YearlyChartPoint> data;

  const YearlyLineChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (data.isEmpty) {
      return const Center(child: Text('No yearly data'));
    }

    final maxY = data.fold<double>(0, (m, p) => m > p.gross ? m : p.gross.toDouble());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Yearly Income Trend',
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
                    getTitlesWidget: (value, meta) {
                      final idx = value.toInt();
                      if (idx < 0 || idx >= data.length) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('${data[idx].year}',
                            style: const TextStyle(fontSize: 10)),
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
                  spots: data.asMap().entries.map((e) {
                    return FlSpot(e.key.toDouble(), e.value.gross.toDouble());
                  }).toList(),
                  isCurved: true,
                  color: Colors.deepOrange,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    color: Colors.deepOrange.withValues(alpha: 0.1),
                  ),
                ),
              ],
              minY: 0,
              maxY: maxY * 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

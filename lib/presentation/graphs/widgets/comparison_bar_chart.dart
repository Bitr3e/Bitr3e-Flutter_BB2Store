import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ComparisonBarChart extends StatelessWidget {
  final int grossIncome;
  final int cashOut;

  const ComparisonBarChart({
    super.key,
    required this.grossIncome,
    required this.cashOut,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxVal = max(grossIncome, cashOut).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cash-In vs Cash-Out',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.center,
              maxY: maxVal > 0 ? maxVal * 1.2 : 1000,
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      return Text('₱${value.toInt()}',
                          style: const TextStyle(fontSize: 10));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const labels = ['Gross', 'Cash-Out'];
                      final idx = value.toInt();
                      if (idx < 0 || idx >= labels.length) {
                        return const SizedBox();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(labels[idx],
                            style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                BarChartGroupData(x: 0, barRods: [
                  BarChartRodData(
                    toY: grossIncome.toDouble(),
                    color: Colors.green,
                    width: 28,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ]),
                BarChartGroupData(x: 1, barRods: [
                  BarChartRodData(
                    toY: cashOut.toDouble(),
                    color: theme.colorScheme.error,
                    width: 28,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _legend(Colors.green, 'Gross Income'),
              const SizedBox(width: 16),
              _legend(theme.colorScheme.error, 'Cash-Out'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:visitdreznica_core/visitdreznica_core.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key, required this.data});

  final List<MonthlyRevenue> data;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall;
    final maxTotal = data.fold<double>(
      0,
      (value, item) => max(value, _stackTotal(item)),
    );
    final interval = _niceInterval(maxTotal);
    final maxY = (maxTotal / interval).floor() * interval + interval;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          spacing: 16,
          children: [
            _Legend(color: AppColors.room, label: 'Smještaj'),
            _Legend(color: AppColors.equipment, label: 'Oprema'),
            _Legend(color: AppColors.activity, label: 'Aktivnosti'),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: interval,
              ),
              barGroups: [
                for (var i = 0; i < data.length; i++) _group(i, data[i]),
              ],
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval,
                    reservedSize: 52,
                    getTitlesWidget: (value, meta) =>
                        Text(_compact(value), style: labelStyle),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();

                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          Formatters.monthShort(data[index].month),
                          style: labelStyle,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final item = data[group.x];
                    return BarTooltipItem(
                      '${Formatters.monthShort(item.month)} ${item.year}\n'
                      'Smještaj: ${Formatters.money(item.rooms)}\n'
                      'Oprema: ${Formatters.money(item.equipment)}\n'
                      'Aktivnosti: ${Formatters.money(item.activities)}\n'
                      'Ukupno: ${Formatters.money(item.total)}',
                      const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static BarChartGroupData _group(int index, MonthlyRevenue item) {
    final rooms = max(0.0, item.rooms);
    final equipment = max(0.0, item.equipment);
    final activities = max(0.0, item.activities);
    final total = rooms + equipment + activities;

    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: total,
          width: 20,
          borderRadius: BorderRadius.circular(3),
          rodStackItems: [
            BarChartRodStackItem(0, rooms, AppColors.room),
            BarChartRodStackItem(rooms, rooms + equipment, AppColors.equipment),
            BarChartRodStackItem(rooms + equipment, total, AppColors.activity),
          ],
        ),
      ],
    );
  }

  static double _stackTotal(MonthlyRevenue item) =>
      max(0.0, item.rooms) +
      max(0.0, item.equipment) +
      max(0.0, item.activities);

  static String _compact(double value) => value >= 1000
      ? '${Formatters.decimal(value / 1000)}k'
      : value.toStringAsFixed(0);

  static double _niceInterval(double maxValue) {
    if (maxValue <= 0) return 100;

    final rough = maxValue / 5;
    final magnitude = pow(10, (log(rough) / ln10).floor()).toDouble();
    final normalized = rough / magnitude;

    final step = normalized <= 1
        ? 1
        : normalized <= 2
        ? 2
        : normalized <= 5
        ? 5
        : 10;

    return step * magnitude;
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}

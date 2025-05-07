import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartWidget extends StatelessWidget {
  const BarChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: 10, color: Colors.blue)],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [BarChartRodData(toY: 20, color: Colors.red)],
          ),
        ],
      ),
    );
  }
}
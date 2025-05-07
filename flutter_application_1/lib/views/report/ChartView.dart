import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartView extends StatelessWidget {
  const ChartView({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: 40,
            title: 'Food',
            color: Colors.blue,
          ),
          PieChartSectionData(
            value: 30,
            title: 'Transport',
            color: Colors.red,
          ),
          PieChartSectionData(
            value: 30,
            title: 'Others',
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
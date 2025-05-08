import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartView extends StatelessWidget {
  final Map<String, double> data; // clé = catégorie, valeur = total

  const ChartView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple];
    final List<PieChartSectionData> sections = [];

    int index = 0;
    data.forEach((category, value) {
      sections.add(
        PieChartSectionData(
          value: value,
          title: category,
          color: colors[index % colors.length],
        ),
      );
      index++;
    });

    return PieChart(
      PieChartData(
        sections: sections,
      ),
    );
  }
}

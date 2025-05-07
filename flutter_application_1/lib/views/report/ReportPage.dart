import 'package:flutter/material.dart';
import 'ChartView.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: const Center(
        child: SizedBox(
          height: 200,
          child: ChartView(),
        ),
      ),
    );
  }
}
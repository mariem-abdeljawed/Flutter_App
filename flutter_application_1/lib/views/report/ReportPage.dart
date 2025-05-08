import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'ChartView.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    // Regrouper les montants par catégorie
    final Map<String, double> categoryTotals = {};
    for (var tx in transactions) {
      final category = tx.category;
      final amount = tx.amount;
      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + amount;
      } else {
        categoryTotals[category] = amount;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Center(
        child: SizedBox(
          height: 300,
          child: ChartView(data: categoryTotals),
        ),
      ),
    );
  }
}

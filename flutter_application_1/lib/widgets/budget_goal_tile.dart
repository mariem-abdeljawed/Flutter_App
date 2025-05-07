import 'package:flutter/material.dart';

class BudgetGoalTile extends StatelessWidget {
  final String category;
  final double amount;

  const BudgetGoalTile({
    super.key,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category),
      trailing: Text('$amount DT'),
    );
  }
}
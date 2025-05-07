import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final String category;
  final String date;
  final double amount;
  final String type;

  const TransactionTile({
    super.key,
    required this.category,
    required this.date,
    required this.amount,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category),
      subtitle: Text(date),
      trailing: Text(
        '${type == 'income' ? '+' : '-'}$amount DT',
        style: TextStyle(
          color: type == 'income' ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
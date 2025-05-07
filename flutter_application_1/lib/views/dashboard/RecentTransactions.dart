import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart'; // Import the Transaction model
import '../../providers/dashboard_provider.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: provider.recentTransactions.length,
            itemBuilder: (context, index) {
              final transaction = provider.recentTransactions[index];
              return ListTile(
                title: Text(transaction.category), // Fixed: Use property access
                subtitle: Text(transaction.date), // Fixed: Use property access
                trailing: Text(
                  '${transaction.type == 'income' ? '+' : '-'}${transaction.amount} DT',
                  style: TextStyle(
                    color: transaction.type == 'income' // Fixed: Use property access
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
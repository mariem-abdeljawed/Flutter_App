import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../providers/transaction_provider.dart';
import '../../services/BudgetService.dart';

class TransactionListPage extends StatelessWidget {
  final VoidCallback? onLogout; // Optional parameter for logout

  const TransactionListPage({super.key, this.onLogout});

  Future<String> _getTransactionType(BuildContext context, Transaction transaction) async {
    final budgetService = BudgetService();
    final db = await budgetService.getDatabase();
    final List<Map<String, dynamic>> categoryMaps = await db.query(
      'categories',
      where: 'id = ?',
      whereArgs: [transaction.category],
    );
    if (categoryMaps.isNotEmpty) {
      final isIncome = categoryMaps.first['isIncome'] == 1;
      return isIncome ? 'income' : 'expense';
    }
    return 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: onLogout,
            ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = provider.transactions[index];
              return FutureBuilder<String>(
                future: _getTransactionType(context, transaction),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const ListTile(
                      title: Text('Loading...'),
                    );
                  }
                  final transactionType = snapshot.data!;
                  return ListTile(
                    title: Text(transaction.category),
                    subtitle: Text(transaction.date),
                    trailing: Text(
                      '${transactionType == 'income' ? '+' : '-'}${transaction.amount} DT',
                      style: TextStyle(
                        color: transactionType == 'income' ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
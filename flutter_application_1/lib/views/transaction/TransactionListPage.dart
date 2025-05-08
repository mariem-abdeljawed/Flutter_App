import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/transaction.dart';
import '../../models/category.dart';
import '../../providers/transaction_provider.dart';
import '../../services/BudgetService.dart';

class TransactionListPage extends StatefulWidget {
  final VoidCallback? onLogout;

  const TransactionListPage({super.key, this.onLogout});

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  Map<String, String> _categoryMap = {}; // id -> name
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final budgetService = BudgetService();
    final categories = await budgetService.getCategories();
    setState(() {
      _categoryMap = {
        for (var cat in categories) (cat.id?.toString() ?? ''): cat.name
      };
      _loading = false;
    });
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
          if (widget.onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: widget.onLogout,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<TransactionProvider>(
              builder: (context, provider, _) {
                final transactions = provider.transactions;

                if (transactions.isEmpty) {
                  return const Center(child: Text('Aucune transaction trouvée'));
                }

                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final isIncome = transaction.type == 'income';
                    final categoryName = _categoryMap[transaction.category] ?? 'Inconnue';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isIncome ? Colors.green : Colors.red,
                        child: Text(
                          (isIncome ? '+' : '-') + transaction.amount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      title: Text(transaction.description ?? 'Aucune description'),
                      subtitle: Text(
                        'Catégorie : $categoryName, Date : ${transaction.date}',
                      ),
                      trailing: Text(transaction.type),
                    );
                  },
                );
              },
            ),
    );
  }
}

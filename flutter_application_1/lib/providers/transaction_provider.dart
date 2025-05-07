import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../services/BudgetService.dart';

class TransactionProvider with ChangeNotifier {
  final BudgetService _budgetService = BudgetService();
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  Future<void> loadTransactions() async {
    _transactions = await _budgetService.getTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _budgetService.addTransaction(transaction);
    await loadTransactions();
  }
}
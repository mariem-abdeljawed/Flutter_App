import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../services/BudgetService.dart';

class TransactionProvider with ChangeNotifier {
  final BudgetService _budgetService = BudgetService();
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  TransactionProvider() {
    loadTransactions(); // Load transactions on initialization
  }

  Future<void> loadTransactions() async {
    try {
      if (kIsWeb) {
        // Handle web case (e.g., in-memory transactions or API)
        _transactions = [];
      } else {
        _transactions = await _budgetService.getTransactions();
      }
      notifyListeners();
    } catch (e) {
      print('Error loading transactions: $e');
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      if (kIsWeb) {
        // Handle web case (e.g., add to in-memory list)
        _transactions.add(transaction);
      } else {
        await _budgetService.addTransaction(transaction);
        _transactions.add(transaction); // Add to local list to avoid reload
      }
      notifyListeners(); // Ensure UI updates
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }
}
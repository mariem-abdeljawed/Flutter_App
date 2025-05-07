import 'package:flutter/foundation.dart';
import '../services/BudgetService.dart';
import '../models/transaction.dart';

class DashboardProvider with ChangeNotifier {
  final BudgetService _budgetService = BudgetService();
  double _balance = 0.0;
  List<Transaction> _recentTransactions = [];

  double get balance => _balance;
  List<Transaction> get recentTransactions => _recentTransactions;

  Future<void> loadDashboardData() async {
    _balance = await _budgetService.calculateBalance();
    _recentTransactions = await _budgetService.getRecentTransactions();
    notifyListeners();
  }
}
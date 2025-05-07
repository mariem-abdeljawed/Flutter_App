import 'package:flutter/foundation.dart';
import '../models/budget_goal.dart';
import '../services/BudgetService.dart';

class BudgetProvider with ChangeNotifier {
  final BudgetService _budgetService = BudgetService();
  List<BudgetGoal> _goals = [];

  List<BudgetGoal> get goals => _goals;

  Future<void> loadGoals() async {
    _goals = await _budgetService.getBudgetGoals();
    notifyListeners();
  }

  Future<void> addGoal(BudgetGoal goal) async {
    await _budgetService.addBudgetGoal(goal);
    await loadGoals();
  }
}
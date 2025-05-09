import 'package:flutter/foundation.dart' hide Category;
import '../models/transaction.dart';
import '../models/category.dart';
import '../services/BudgetService.dart';

class TransactionProvider with ChangeNotifier {
  final BudgetService _budgetService = BudgetService();
  List<Transaction> _transactions = [];
  List<Category> _categories = [];

  List<Transaction> get transactions => _transactions;
  List<Category> get categories => _categories;

  TransactionProvider() {
    loadTransactions();
    loadCategories();
  }

  Future<void> loadTransactions() async {
    try {
      if (kIsWeb) {
        _transactions = [];
      } else {
        _transactions = await _budgetService.getTransactions();
      }
      notifyListeners();
    } catch (e) {
      print('Error loading transactions: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      if (kIsWeb) {
        _categories = [
          Category(id: 1, name: 'Salary', isIncome: 1),
          Category(id: 2, name: 'Food', isIncome: 0),
          Category(id: 3, name: 'Utilities', isIncome: 0),
        ];
      } else {
        _categories = await _budgetService.getCategories();
        if (_categories.isEmpty) {
          await _budgetService.addCategory('Salary', 1);
          await _budgetService.addCategory('Food', 0);
          await _budgetService.addCategory('Utilities', 0);
          _categories = await _budgetService.getCategories();
        }
      }
      print('Categories loaded in TransactionProvider: ${_categories.map((c) => c.name).toList()}');
      notifyListeners();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      if (kIsWeb) {
        _transactions.add(transaction);
      } else {
        await _budgetService.addTransaction(transaction);
        _transactions.add(transaction);
      }
      notifyListeners();
    } catch (e) {
      print('Error adding transaction: $e');
      throw e;
    }
  }

  Future<void> addCategory(String name, int isIncome) async {
    try {
      if (kIsWeb) {
        final newId = _categories.isEmpty ? 1 : _categories.last.id! + 1;
        _categories.add(Category(id: newId, name: name, isIncome: isIncome));
      } else {
        await _budgetService.addCategory(name, isIncome);
        await loadCategories();
      }
      print('Categories after adding $name: ${_categories.map((c) => c.name).toList()}');
      notifyListeners();
    } catch (e) {
      print('Error adding category: $e');
      throw e;
    }
  }

  Future<void> updateCategory(Category updatedCategory) async {
  final index = _categories.indexWhere((c) => c.id == updatedCategory.id);
  if (index != -1) {
    _categories[index] = updatedCategory;
    // Si tu utilises SQLite ou un autre backend, ajoute ici la mise à jour dans la base de données.
    notifyListeners();
  }
}


  Future<void> deleteCategory(int id) async {
    try {
      if (kIsWeb) {
        _categories.removeWhere((category) => category.id == id);
      } else {
        final db = await _budgetService.getDatabase();
        await db.delete(
          'categories',
          where: 'id = ?',
          whereArgs: [id],
        );
        await loadCategories();
      }
      print('Categories after deleting ID $id: ${_categories.map((c) => c.name).toList()}');
      notifyListeners();
    } catch (e) {
      print('Error deleting category: $e');
      throw e;
    }
  }
}
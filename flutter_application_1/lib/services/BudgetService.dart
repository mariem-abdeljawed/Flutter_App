import 'package:sqflite/sqflite.dart' as sqflite;
import '../../models/budget_goal.dart';
import '../../models/transaction.dart';
import 'database_service.dart';

class BudgetService {
  Future<sqflite.Database> get _database async => await DatabaseService.instance.database;

  Future<void> addBudgetGoal(BudgetGoal goal) async {
    final db = await _database;
    final goalMap = {
      'id': goal.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'categoryId': goal.category,
      'maxAmount': goal.amount,
      'month': '${goal.month}-${goal.year}',
    };
    await db.insert('budget_goals', goalMap,
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  }

  Future<List<BudgetGoal>> getBudgetGoals() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('budget_goals');
    return List.generate(maps.length, (i) {
      final map = maps[i];
      final monthYear = (map['month'] as String?)?.split('-') ?? ['0', '0'];
      return BudgetGoal(
        id: int.tryParse(map['id'].toString()) ?? 0,
        category: map['categoryId']?.toString() ?? '',
        amount: (map['maxAmount'] as num?)?.toDouble() ?? 0.0,
        month: int.tryParse(monthYear[0]) ?? 0,
        year: int.tryParse(monthYear.length > 1 ? monthYear[1] : '0') ?? 0,
      );
    });
  }

  Future<void> addTransaction(Transaction transaction) async {
    final db = await _database;
    final transactionMap = {
      'id': transaction.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'amount': transaction.amount,
      'date': transaction.date,
      'categoryId': transaction.category, // Fixed: Use 'category' from model, maps to 'categoryId' in DB
      'description': transaction.description,
    };
    await db.insert('transactions', transactionMap,
        conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  }

  Future<List<Transaction>> getTransactions() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    final transactions = <Transaction>[];
    for (var map in maps) {
      final categoryMaps = await db.query(
        'categories',
        where: 'id = ?',
        whereArgs: [map['categoryId']],
      );
      final type = categoryMaps.isNotEmpty && (categoryMaps.first['isIncome'] as int?) == 1
          ? 'income'
          : 'expense';
      transactions.add(Transaction(
        id: int.tryParse(map['id'].toString()) ?? 0,
        amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
        category: map['categoryId']?.toString() ?? '', // Fixed: Map 'categoryId' from DB to 'category' in model
        type: type, // Now matches the Transaction constructor
        date: map['date']?.toString() ?? '',
        description: map['description']?.toString(),
      ));
    }
    return transactions;
  }

  Future<double> calculateBalance() async {
    final transactions = await getTransactions();
    double balance = 0.0;
    for (var transaction in transactions) {
      if (transaction.type == 'income') { // Fixed: Use the 'type' property
        balance += transaction.amount;
      } else {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  Future<List<Transaction>> getRecentTransactions() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
      limit: 5,
    );
    final transactions = <Transaction>[];
    for (var map in maps) {
      final categoryMaps = await db.query(
        'categories',
        where: 'id = ?',
        whereArgs: [map['categoryId']],
      );
      final type = categoryMaps.isNotEmpty && (categoryMaps.first['isIncome'] as int?) == 1
          ? 'income'
          : 'expense';
      transactions.add(Transaction(
        id: int.tryParse(map['id'].toString()) ?? 0,
        amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
        category: map['categoryId']?.toString() ?? '', // Fixed: Map 'categoryId' from DB to 'category' in model
        type: type, // Now matches the Transaction constructor
        date: map['date']?.toString() ?? '',
        description: map['description']?.toString(),
      ));
    }
    return transactions;
  }

  Future<sqflite.Database> getDatabase() async => await _database;
}
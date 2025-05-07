import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('budget.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE categories (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      isIncome INTEGER NOT NULL
    )
    ''');
    await db.execute('''
    CREATE TABLE transactions (
      id TEXT PRIMARY KEY,
      amount REAL NOT NULL,
      date TEXT NOT NULL,
      categoryId TEXT NOT NULL,
      description TEXT,
      FOREIGN KEY (categoryId) REFERENCES categories(id)
    )
    ''');
    await db.execute('''
    CREATE TABLE budget_goals (
      id TEXT PRIMARY KEY,
      categoryId TEXT NOT NULL,
      maxAmount REAL NOT NULL,
      month TEXT NOT NULL,
      FOREIGN KEY (categoryId) REFERENCES categories(id)
    )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
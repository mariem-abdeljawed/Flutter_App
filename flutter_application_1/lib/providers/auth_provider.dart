import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert'; // Ajout de l'importation

class AuthProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> signIn(String email, String password) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList('users') ?? [];
      final users = usersJson.map((json) => User.fromJson(jsonDecode(json))).toList();
      final foundUser = users.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Email ou mot de passe incorrect'),
      );
      _user = foundUser;
      notifyListeners();
    } else {
      final db = await DatabaseService.instance.database;
      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

      if (result.isNotEmpty) {
        _user = User(
          id: result.first['id'] as String,
          email: result.first['email'] as String,
          password: result.first['password'] as String,
        );
        notifyListeners();
      } else {
        throw Exception('Email ou mot de passe incorrect');
      }
    }
  }

  Future<void> signUp(String email, String password) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList('users') ?? [];
      final users = usersJson.map((json) => User.fromJson(jsonDecode(json))).toList();

      if (users.any((user) => user.email == email)) {
        throw Exception('Cet email est déjà utilisé');
      }

      final id = const Uuid().v4();
      final newUser = User(id: id, email: email, password: password);
      users.add(newUser);
      final updatedUsersJson = users.map((user) => jsonEncode(user.toJson())).toList();
      await prefs.setStringList('users', updatedUsersJson);

      print('Utilisateur inscrit (web) : id=$id, email=$email, password=$password');
    } else {
      final db = await DatabaseService.instance.database;
      final id = const Uuid().v4();
      try {
        await db.insert(
          'users',
          {
            'id': id,
            'email': email,
            'password': password,
          },
          conflictAlgorithm: ConflictAlgorithm.fail,
        );
        final users = await db.query('users');
        print('Utilisateurs dans la base (mobile) : $users');
      } catch (e) {
        throw Exception('Cet email est déjà utilisé');
      }
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    _user = null;
    notifyListeners();
  }

  Future<List<User>> getAllUsers() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList('users') ?? [];
      final users = usersJson.map((json) => User.fromJson(jsonDecode(json))).toList();
      print('Utilisateurs récupérés (web) : $usersJson');
      return users;
    } else {
      final db = await DatabaseService.instance.database;
      final result = await db.query('users');
      return result.map((e) => User.fromJson(e)).toList();
    }
  }


  
}
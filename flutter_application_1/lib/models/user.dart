import 'dart:convert';

class User {
  final String id;
  final String email;
  final String password;

  User({required this.id, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
    );
  }
}
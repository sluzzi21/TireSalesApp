import 'dart:convert';

class User {
  final String id;
  final String username;
  String passwordHash;
  final bool isAdmin;
  final DateTime createdAt;
  bool requirePasswordChange;

  User({
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.isAdmin,
    required this.createdAt,
    this.requirePasswordChange = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'passwordHash': passwordHash,
    'isAdmin': isAdmin,
    'createdAt': createdAt.toIso8601String(),
    'requirePasswordChange': requirePasswordChange,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    username: json['username'],
    passwordHash: json['passwordHash'],
    isAdmin: json['isAdmin'],
    createdAt: DateTime.parse(json['createdAt']),
    requirePasswordChange: json['requirePasswordChange'] ?? false,
  );
}

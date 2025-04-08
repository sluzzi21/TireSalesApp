import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:universal_html/html.dart' as html;
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class AuthService {
  static const String _storageKey = 'users';
  static const String _currentUserKey = 'currentUser';
  final _uuid = const Uuid();

  AuthService() {
    _initializeAdminIfNeeded();
  }

  void _initializeAdminIfNeeded() {
    final usersJson = html.window.localStorage[_storageKey];
    if (usersJson == null || json.decode(usersJson).isEmpty) {
      final adminUser = User(
        id: _uuid.v4(),
        username: 'admin',
        passwordHash: _hashPassword('admin123'),
        isAdmin: true,
        createdAt: DateTime.now(),
      );
      _saveUsers([adminUser]);
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  List<User> _loadUsers() {
    final usersJson = html.window.localStorage[_storageKey];
    if (usersJson == null) return [];
    final List<dynamic> usersList = json.decode(usersJson);
    return usersList.map((u) => User.fromJson(u)).toList();
  }

  void _saveUsers(List<User> users) {
    final usersJson = json.encode(users.map((u) => u.toJson()).toList());
    html.window.localStorage[_storageKey] = usersJson;
  }

  User? getCurrentUser() {
    final currentUserJson = html.window.localStorage[_currentUserKey];
    if (currentUserJson == null) return null;
    return User.fromJson(json.decode(currentUserJson));
  }

  void setCurrentUser(User user) {
    html.window.localStorage[_currentUserKey] = json.encode(user.toJson());
  }

  void clearCurrentUser() {
    html.window.localStorage.remove(_currentUserKey);
  }

  bool login(String username, String password) {
    final users = _loadUsers();
    final user = users.firstWhere(
      (u) => u.username == username && u.passwordHash == _hashPassword(password),
      orElse: () => throw Exception('Invalid credentials'),
    );
    setCurrentUser(user);
    return true;
  }

  void logout() {
    clearCurrentUser();
  }

  void createUser(String username, String initialPassword, bool isAdmin) {
    final currentUser = getCurrentUser();
    if (currentUser == null || !currentUser.isAdmin) {
      throw Exception('Only admins can create users');
    }

    final users = _loadUsers();
    if (users.any((u) => u.username == username)) {
      throw Exception('Username already exists');
    }

    final newUser = User(
      id: _uuid.v4(),
      username: username,
      passwordHash: _hashPassword(initialPassword),
      isAdmin: isAdmin,
      createdAt: DateTime.now(),
      requirePasswordChange: true,
    );

    users.add(newUser);
    _saveUsers(users);
  }

  void changePassword(String username, String currentPassword, String newPassword) {
    final users = _loadUsers();
    final userIndex = users.indexWhere((u) => u.username == username);
    if (userIndex == -1) throw Exception('User not found');

    final user = users[userIndex];
    if (user.passwordHash != _hashPassword(currentPassword)) {
      throw Exception('Invalid current password');
    }

    user.passwordHash = _hashPassword(newPassword);
    user.requirePasswordChange = false;
    users[userIndex] = user;
    _saveUsers(users);

    final currentUser = getCurrentUser();
    if (currentUser?.username == username) {
      setCurrentUser(user);
    }
  }

  void resetUserPassword(String username, String newPassword) {
    final currentUser = getCurrentUser();
    if (currentUser == null || !currentUser.isAdmin) {
      throw Exception('Only admins can reset passwords');
    }

    final users = _loadUsers();
    final userIndex = users.indexWhere((u) => u.username == username);
    if (userIndex == -1) throw Exception('User not found');

    final user = users[userIndex];
    user.passwordHash = _hashPassword(newPassword);
    user.requirePasswordChange = true;
    users[userIndex] = user;
    _saveUsers(users);
  }

  List<User> getUsers() {
    final currentUser = getCurrentUser();
    if (currentUser == null || !currentUser.isAdmin) {
      throw Exception('Only admins can view user list');
    }
    return _loadUsers();
  }
}

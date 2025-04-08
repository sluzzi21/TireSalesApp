import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  User? _currentUser;

  AuthProvider(this._authService) {
    _currentUser = _authService.getCurrentUser();
  }

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  Future<void> login(String username, String password) async {
    try {
      _authService.login(username, password);
      _currentUser = _authService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void logout() {
    _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  void createUser(String username, String initialPassword, bool isAdmin) {
    _authService.createUser(username, initialPassword, isAdmin);
    notifyListeners();
  }

  void changePassword(String currentPassword, String newPassword) {
    if (_currentUser == null) throw Exception('No user logged in');
    _authService.changePassword(_currentUser!.username, currentPassword, newPassword);
    _currentUser = _authService.getCurrentUser();
    notifyListeners();
  }

  void resetUserPassword(String username, String newPassword) {
    _authService.resetUserPassword(username, newPassword);
    notifyListeners();
  }

  List<User> getUsers() {
    return _authService.getUsers();
  }
}

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/shared_prefs_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;

  /// Load user yang sedang login (dari SharedPreferences)
  Future<void> loadCurrentUser() async {
    _currentUser = await SharedPrefsService.getCurrentUser();
    notifyListeners();
  }

  /// Login
  Future<bool> login(String email, String password) async {
    final users = await SharedPrefsService.getUsers();
    final user = users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => User(name: '', email: '', password: ''),
    );
    if (user.email.isNotEmpty) {
      await SharedPrefsService.saveCurrentUser(user);
      _currentUser = user;
      notifyListeners();

      // **JANGAN panggil Provider.of di sini karena tidak ada context**

      return true;
    }
    return false;
  }

  /// Register
  Future<bool> register(User user) async {
    final users = await SharedPrefsService.getUsers();
    if (users.any((u) => u.email == user.email)) {
      return false; // Email sudah terdaftar
    }
    users.add(user);
    await SharedPrefsService.saveUsers(users);
    await SharedPrefsService.saveCurrentUser(user);
    _currentUser = user;
    notifyListeners();
    return true;
  }

  /// Logout
  Future<void> logout() async {
    await SharedPrefsService.logout();
    _currentUser = null;
    notifyListeners();
  }

  /// Mendapatkan semua user yang tersimpan (untuk update profile)
  Future<List<User>> getAllUsers() async {
    return await SharedPrefsService.getUsers();
  }

  /// Menyimpan ulang semua user
  Future<void> saveAllUsers(List<User> users) async {
    await SharedPrefsService.saveUsers(users);
  }

  /// Menyetel user yang sedang login
  Future<void> setCurrentUser(User user) async {
    await SharedPrefsService.saveCurrentUser(user);
    _currentUser = user;
    notifyListeners();
  }
}

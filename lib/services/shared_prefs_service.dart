import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class SharedPrefsService {
  static const String _usersKey = 'users';
  static const String _currentUserKey = 'current_user';

  /// Simpan list user ke SharedPreferences
  static Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final userList = users.map((u) => u.toJson()).toList();
    await prefs.setString(_usersKey, jsonEncode(userList));
  }

  /// Ambil list user dari SharedPreferences
  static Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_usersKey);
    if (jsonStr == null) return [];
    final List<dynamic> data = jsonDecode(jsonStr);
    return data.map((item) => User.fromJson(item)).toList();
  }

  /// Simpan user yang sedang login ke SharedPreferences
  static Future<void> saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  /// Ambil user yang sedang login dari SharedPreferences
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_currentUserKey);
    if (jsonStr == null) return null;
    return User.fromJson(jsonDecode(jsonStr));
  }

  /// Hapus session user (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }
}

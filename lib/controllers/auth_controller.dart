import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _keyUsername = 'username';
  static const String _keyIsLogin = 'isLogin';
  static const String _keyUsers = 'users';

  Future<void> login(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setBool(_keyIsLogin, true);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLogin) ?? false;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> register(String username, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usersData = prefs.getStringList(_keyUsers) ?? [];
    Map<String, String> userData = {
      'username': username,
      'email': email,
      'password': password,
    };
    usersData.add(jsonEncode(userData));
    await prefs.setStringList(_keyUsers, usersData);
  }

  Future<bool> isRegistered(String username) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usersData = prefs.getStringList(_keyUsers) ?? [];
    for (String userDataString in usersData) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      if (userData['username'] == username) {
        return true;
      }
    }
    return false;
  }

  Future<bool> validateLogin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usersData = prefs.getStringList(_keyUsers) ?? [];
    for (String userDataString in usersData) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      if (userData['username'] == username &&
          userData['password'] == password) {
        return true;
      }
    }
    return false;
  }

  Future<Map<String, String>?> getUserData(String username) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usersData = prefs.getStringList(_keyUsers) ?? [];
    for (String userDataString in usersData) {
      Map<String, dynamic> userData = jsonDecode(userDataString);
      if (userData['username'] == username) {
        return {
          'username': userData['username'],
          'email': userData['email'],
          'password': userData['password'],
        };
      }
    }
    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  String _token = "";
  int _userId = 0;

  String get token => _token;
  int get userId => _userId;

  void saveToken(String token) async {
    SharedPreferences value = await _pref;

    value.setString("token", token);
  }

  void saveUserId(int userId) async {
    SharedPreferences value = await _pref;

    value.setInt("userId", userId);
  }

  Future<String> getToken() async {
    SharedPreferences value = await _pref;

    if (value.containsKey("token")) {
      String data = value.getString("token")!;
      _token = data;

      notifyListeners();
      return data;
    } else {
      _token = "";

      notifyListeners();
      return "";
    }
  }

  Future<int> getUserId() async {
    SharedPreferences value = await _pref;

    if (value.containsKey("userId")) {
      int data = value.getInt("userId")!;
      _userId = data;

      notifyListeners();
      return data;
    } else {
      _userId = 0;

      notifyListeners();
      return 0;
    }
  }

  void logout() async {
    final value = await _pref;

    value.clear();
  }

  Future<int> getIdUser() async {
    // contoh asumsi kamu menyimpan ID sebagai string di SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id_user') ?? 0;
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_models.dart';

class StorageServices {

  static late SharedPreferences _sharedPreferences;

  static Future<void> initPrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static const String _uSER = 'user';

  static Future<bool> setUser(String value) async {
    await initPrefs();
    return _sharedPreferences.setString(_uSER, value);
  }

  static Future<UserModels?> get user async {
    await initPrefs();
    final storedVal = _sharedPreferences.getString(_uSER);
    if (storedVal == null) {
      return null;
    }
    final value = json.decode(storedVal) as Map<String, dynamic>?;
    if (value != null) {
      return UserModels.fromJson(value);
    }
    return null;
  }
}
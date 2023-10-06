// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceClass {
  static Future<void> SetSharedData(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is int) {
      prefs.setInt(key, value);
    } else if (value is String) {
      prefs.setString(key, value);
    } else if (value is bool) {
      prefs.setBool(key, value);
    } else {
      print("Invalid Type");
    }
  }

  static Future<dynamic> GetSharedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic obj = prefs.get(key);
    print("color data" + obj.toString());
    return obj;
  }

  static Future<bool> removeSharedData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<bool> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataCleared = await prefs.clear();
    return dataCleared;
  }
}

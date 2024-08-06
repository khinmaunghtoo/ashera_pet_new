import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DioSharedPreferenceUtil{
  //設定JSON
  Future<bool> setJSON(String key, dynamic jsonVal) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(jsonVal);
    return sharedPreferences.setString(key, jsonString);
  }

  //取得JSON
  dynamic getJSON(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? jsonString = sharedPreferences.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  //刪除Dio緩存
  Future<bool> remove(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove(key);
  }
}
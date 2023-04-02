import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  final String _key;

  SharedPreferencesHelper({@required String key}) : _key = key;

  Future<void> saveData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(_key)) {
      await prefs.remove(_key);
    }

    final jsonData = jsonEncode(data);
    
    await prefs.setString(_key, jsonData);
  }

  Future<Map<String, dynamic>> readData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.get(_key);
    if (jsonData == null) return null;
    final data = json.decode(jsonData);
    return data;
  }

  Future<void> deleteData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

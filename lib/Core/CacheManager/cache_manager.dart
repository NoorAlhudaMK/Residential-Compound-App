import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Data/Models/user_model.dart';

class CacheManager {
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> saveSensitiveData({required String token}) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  static Future<void> saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());

    await prefs.setString('user_data', userJson);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<UserModel> getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJsonString = prefs.getString('user_data');

    if (userJsonString != null) {
      Map<String, dynamic> userMap = jsonDecode(userJsonString);
      return UserModel.fromJson(userMap);
    } else {
      throw Exception("لا توجد بيانات مستخدم محفوظة في الكاش");
    }
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await _secureStorage.deleteAll();
    await prefs.clear();
  }
}

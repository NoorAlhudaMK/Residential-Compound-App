import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../Core/AppConstants/app_constants.dart';
import '../../Core/CacheManager/cache_manager.dart';
import '../Models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String username, String password) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    final response = await http.post(
      Uri.parse(AppConstants.loginEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "jsonrpc": "2.0",
        "params": {
          "db": AppConstants.dbName,
          "login": username,
          "password": password,
          "device_token": fcmToken ?? "no_token"
        }
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("The data : ${data}");
      if (data['success'] == true && data['data'] != null) {
        return UserModel.fromJson(data['data'], token: data['data']['token']);
      //  return data['data']['user']['name'] ?? "مستخدم";
      } else {
        throw Exception(data['message'] ?? "خطأ في بيانات الدخول");
      }
    } else {
      throw Exception("فشل الاتصال بالسيرفر");
    }
  }

  Future<bool> checkUserAccess(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/auth/access_groups'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        List<dynamic> allowedApps = data['data']['allowed_apps'];

        return allowedApps.contains('resident');
      }
    }
    return false;
  }

  Future<UserModel> getUserProfile(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/profile'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        return UserModel.fromJson(data['data'], token: token);
      }
    }
    throw Exception("فشل في جلب بيانات المستخدم");
  }

  Future<void> sendDeviceToken(String authToken, String firebaseToken) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/user/device_token'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode({
        "device_token": firebaseToken,
        "platform": "android", ///!TODO: أو يمكنك جعلها ديناميكية
        "app_name": "resident"
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("فشل في إرسال توكن الجهاز");
    }
  }

  // دالة موحدة لجلب البيانات وتحديث التخزين
  Future<UserModel> fetchAndCacheUserProfile(String authToken) async {
    // 1. التأكد من الصلاحية
    bool hasAccess = await checkUserAccess(authToken);
    if (!hasAccess) throw Exception("ليس لديك صلاحية");

    // 2. جلب البيانات
    final user = await getUserProfile(authToken);

    // 3. حفظ الـ Cache
    await CacheManager.saveSensitiveData(token: authToken);
    await CacheManager.saveUserData(user);
    // 4. أخيراً: إرسال توكن الجهاز (الخطوة الأخيرة)
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await sendDeviceToken(authToken, fcmToken);
      }
    } catch (e) {
      print("خطأ في إرسال التوكن: $e");
    }

    return user;
  }

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/auth/logout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to logout');
    }
  }
}
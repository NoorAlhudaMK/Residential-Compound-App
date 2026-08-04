import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../Core/AppConstants/app_constants.dart';
import '../../Core/CacheManager/cache_manager.dart';
import '../Models/user_model.dart';

class AuthRepository {
  // دالة مساعدة للتعامل مع الأخطاء العامة و Timeout مع إضافة طباعة التتبع
  Future<http.Response> _safeRequest(
      String methodName,
      String url,
      Map<String, String> headers,
      Future<http.Response> Function() requestFn, {
        Object? body,
      }) async {
    // طباعة تفاصيل الـ Request
    if (kDebugMode) {
      print('==================== [REQUEST: $methodName] ====================');
      print('URL: $url');
      print('Headers: $headers');
      if (body != jsonEncode(null)) {
        print('Body: $body');
      }
      print('===============================================================');
    }

    try {
      final response = await requestFn().timeout(const Duration(seconds: 15));

      // طباعة تفاصيل الـ Response
      if (kDebugMode) {
        print('==================== [RESPONSE: $methodName] ====================');
        print('Status Code: ${response.statusCode}');
        print('Body: ${response.body}');
        print('================================================================');
      }

      return response;
    } on TimeoutException {
      if (kDebugMode) {
        print('---------------- [TIMEOUT ERROR: $methodName] ----------------');
      }
      throw Exception(
        "انتهت مهلة الاتصال بالسيرفر، يرجى التحقق من شبكة الإنترنت.",
      );
    } catch (e) {
      if (kDebugMode) {
        print('---------------- [EXCEPTION ERROR: $methodName] ----------------');
        print('Error details: $e');
      }
      throw Exception("فشل الاتصال بالسيرفر، تأكد من اتصالك بالإنترنت.");
    }
  }

  Future<UserModel> login(String username, String password) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    final url = AppConstants.loginEndpoint;
    final headers = {"Content-Type": "application/json"};
    final requestBody = jsonEncode({
      "jsonrpc": "2.0",
      "params": {
        "db": AppConstants.dbName,
        "login": username,
        "password": password,
        "device_token": fcmToken ?? "no_token",
      },
    });

    final response = await _safeRequest(
      "LOGIN",
      url,
      headers,
          () => http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody,
      ),
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return UserModel.fromJson(data['data'], token: data['data']['token']);
      } else {
        throw Exception(data['message'] ?? "خطأ في بيانات الدخول");
      }
    } else {
      throw Exception("خطأ في الخادم (رمز الخطأ: ${response.statusCode})");
    }
  }

  Future<bool> checkUserAccess(String token) async {
    final url = '${AppConstants.baseUrl}api/v1/auth/access-groups';
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<dynamic> allowedApps = data['data']['allowed_apps'];
          return allowedApps.contains('resident');
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel> getUserProfile(String token) async {
    final url = '${AppConstants.baseUrl}api/user/profile';
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final response = await _safeRequest(
      "GET_USER_PROFILE",
      url,
      headers,
          () => http.get(
        Uri.parse(url),
        headers: headers,
      ),
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
    final url = '${AppConstants.baseUrl}api/user/device_token';
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
    };
    final requestBody = jsonEncode({
      "device_token": firebaseToken,
      "platform": "android",
      "app_name": "resident",
    });

    final response = await _safeRequest(
      "SEND_DEVICE_TOKEN",
      url,
      headers,
          () => http.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody,
      ),
      body: requestBody,
    );

    if (response.statusCode != 200) {
      throw Exception("فشل في إرسال توكن الجهاز");
    }
  }

  Future<UserModel> fetchAndCacheUserProfile(String authToken) async {
    bool hasAccess = await checkUserAccess(authToken);
    if (!hasAccess) throw Exception("ليس لديك صلاحية");

    final user = await getUserProfile(authToken);

    await CacheManager.saveSensitiveData(token: authToken);
    await CacheManager.saveUserData(user);
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await sendDeviceToken(authToken, fcmToken);
      }
    } catch (e) {
      if (kDebugMode) {
        print("خطأ في إرسال التوكن: $e");
      }
    }

    return user;
  }

  Future<void> logout(String token) async {
    final url = '${AppConstants.baseUrl}/api/v1/auth/logout';
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await _safeRequest(
      "LOGOUT",
      url,
      headers,
          () => http.post(
        Uri.parse(url),
        headers: headers,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل تسجيل الخروج');
    }
  }
}
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../Core/AppConstants/app_constants.dart';
import '../Models/notification_model.dart';

class NotificationRepository {
  Future<List<NotificationModel>> fetchNotifications(String token) async {
    final url = '${AppConstants.baseUrl}api/v1/notifications';
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // طباعة تفاصيل الـ Request
    if (kDebugMode) {
      print('==================== [REQUEST: FETCH_NOTIFICATIONS] ====================');
      print('URL: $url');
      print('Headers: $headers');
      print('========================================================================');
    }

    try {
      final response = await http
          .get(
        Uri.parse(url),
        headers: headers,
      )
          .timeout(const Duration(seconds: 15));

      // طباعة تفاصيل الـ Response
      if (kDebugMode) {
        print('==================== [RESPONSE: FETCH_NOTIFICATIONS] ====================');
        print('Status Code: ${response.statusCode}');
        print('Body: ${response.body}');
        print('=========================================================================');
      }

      if (response.statusCode == 200) {
        List data = json.decode(response.body)['data']['notifications'];
        return data.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load notifications (رمز الخطأ: ${response.statusCode})');
      }
    } on TimeoutException {
      if (kDebugMode) {
        print('---------------- [TIMEOUT ERROR: FETCH_NOTIFICATIONS] ----------------');
      }
      throw Exception(
        "انتهت مهلة الاتصال بالسيرفر، يرجى التحقق من شبكة الإنترنت.",
      );
    } catch (e) {
      if (kDebugMode) {
        print('---------------- [EXCEPTION ERROR: FETCH_NOTIFICATIONS] ----------------');
        print('Error details: $e');
      }
      throw Exception("فشل الاتصال بالسيرفر، تأكد من اتصالك بالإنترنت.");
    }
  }
}
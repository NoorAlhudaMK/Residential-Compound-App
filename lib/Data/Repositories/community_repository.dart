import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../Core/AppConstants/app_constants.dart';
import '../Models/announcement_model.dart';

class CommunityRepository {
  Future<List<AnnouncementModel>> fetchAnnouncements(String token) async {
    final url = '${AppConstants.baseUrl}/api/user/ads_banner';
    final headers = {"Authorization": "Bearer $token"};

    // طباعة تفاصيل الـ Request
    if (kDebugMode) {
      print('==================== [REQUEST: FETCH_ANNOUNCEMENTS] ====================');
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
        print('==================== [RESPONSE: FETCH_ANNOUNCEMENTS] ====================');
        print('Status Code: ${response.statusCode}');
        print('Body: ${response.body}');
        print('=========================================================================');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> banners = body['data']['banners'];
        return banners.map((json) => AnnouncementModel.fromJson(json)).toList();
      } else {
        throw Exception("فشل جلب الإعلانات (رمز الخطأ: ${response.statusCode})");
      }
    } on TimeoutException {
      if (kDebugMode) {
        print('---------------- [TIMEOUT ERROR: FETCH_ANNOUNCEMENTS] ----------------');
      }
      throw Exception(
        "انتهت مهلة الاتصال بالسيرفر، يرجى التحقق من شبكة الإنترنت.",
      );
    } catch (e) {
      if (kDebugMode) {
        print('---------------- [EXCEPTION ERROR: FETCH_ANNOUNCEMENTS] ----------------');
        print('Error details: $e');
      }
      throw Exception("فشل الاتصال بالسيرفر، تأكد من اتصالك بالإنترنت.");
    }
  }
}
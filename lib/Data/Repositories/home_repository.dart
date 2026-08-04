import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../Core/AppConstants/app_constants.dart';
import '../Models/dashboard_data_model.dart';

class HomeRepository {
  Future<DashboardDataModel> getHomeData(String token) async {
    final url = '${AppConstants.baseUrl}/api/v1/resident/home';
    final headers = {'Authorization': 'Bearer $token'};

    // طباعة تفاصيل الـ Request للتأكد منها
    print('==================== [REQUEST] ====================');
    print('URL: $url');
    print('Headers: $headers');
    print('===================================================');

    try {
      final response = await http
          .get(
        Uri.parse(url),
        headers: headers,
      )
          .timeout(const Duration(seconds: 15));

      // طباعة تفاصيل الـ Response للتأكد منها
      print('==================== [RESPONSE] ====================');
      print('Status Code: ${response.statusCode}');
      print('Body: ${response.body}');
      print('====================================================');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return DashboardDataModel.fromJson(json['data']);
      } else {
        throw Exception("خطأ في الخادم (رمز الخطأ: ${response.statusCode})");
      }
    } on TimeoutException {
      print('---------------- [TIMEOUT ERROR] ----------------');
      throw Exception(
        "انتهت مهلة الاتصال بالسيرفر، يرجى التحقق من شبكة الإنترنت.",
      );
    } catch (e) {
      print('---------------- [EXCEPTION ERROR] ----------------');
      print('Error details: $e');
      throw Exception("فشل الاتصال بالسيرفر، تأكد من اتصالك بالإنترنت.");
    }
  }
}
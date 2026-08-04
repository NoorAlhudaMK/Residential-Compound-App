import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../Core/AppConstants/app_constants.dart';
import '../Models/visitor_model.dart';

class VisitorRepository {
  // دالة مساعدة لطباعة الطلبات واستجابات السيرفر بأمان
  Future<http.Response> _safeRequest(
      String methodName,
      String url,
      Map<String, String> headers,
      Future<http.Response> Function() requestFn, {
        Object? body,
      }) async {
    if (kDebugMode) {
      print('==================== 🚀 [REQUEST: $methodName] ====================');
      print('URL: $url');
      print('Headers: $headers');
      if (body != null) {
        print('Body: $body');
      }
      print('=================================================================');
    }

    try {
      final response = await requestFn().timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('<=================== 📥 [RESPONSE: $methodName] ===================');
        print('StatusCode: ${response.statusCode}');
        print('Body: ${response.body}');
        print('=================================================================');
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

  Future<List<VisitorModel>> getVisitors(
      String token, {
        String? status,
        String? search,
        int page = 1,
        int perPage = 15,
      }) async {
    final queryParameters = {
      if (status != null && status.isNotEmpty) 'status': status,
      if (search != null && search.isNotEmpty) 'search': search,
      'page': page.toString(),
      'per_page': perPage.toString(),
    };

    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/security/expected-visitors')
        .replace(queryParameters: queryParameters);

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final response = await _safeRequest(
      "GET_VISITORS",
      uri.toString(),
      headers,
          () => http.get(uri, headers: headers),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<dynamic> visitorsList = json['data']['visitors'];
      return visitorsList.map((item) => VisitorModel.fromJson(item)).toList();
    } else {
      throw Exception("فشل جلب الزوار: ${response.statusCode}");
    }
  }

  Future<VisitorModel> addVisitor({
    required String token,
    required String name,
    required String phone,
    required int unitId,
    required String validFrom,
    required String validTo,
    required bool hasCar,
    required String carPlate,
    required int residentId,
  }) async {
    final url = '${AppConstants.baseUrl}/api/user/add_new_visitor';
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final requestBody = jsonEncode({
      "visitor_name": name,
      "visitor_phone": phone,
      "unit_id": unitId,
      "valid_from": validFrom,
      "valid_to": validTo,
      "has_car": hasCar,
      "car_plate": carPlate,
      "resident_id": residentId,
    });

    final response = await _safeRequest(
      "ADD_VISITOR",
      url,
      headers,
          () => http.post(Uri.parse(url), headers: headers, body: requestBody),
      body: requestBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['data'] != null) {
        return VisitorModel.fromJson(responseData['data']['visitor']);
      } else {
        throw Exception("السيرفر عاد بنجاح ولكن البيانات فارغة");
      }
    } else {
      throw Exception("فشل الاتصال بالسيرفر: ${response.statusCode}");
    }
  }
}
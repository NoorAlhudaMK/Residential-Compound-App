import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../Core/AppConstants/app_constants.dart';
import '../Models/maintenance_category_model.dart';
import '../Models/maintenance_ticket_model.dart';
import '../Models/priority_model.dart';
import '../Models/status_model.dart';

class MaintenanceRepository {
  Future<http.Response> _safeRequest(
      String methodName,
      String url,
      Map<String, String> headers,
      Future<http.Response> Function() requestFn, {
        Object? body,
      }) async {
    if (kDebugMode) {
      print('==================== [REQUEST: $methodName] ====================');
      print('URL: $url');
      print('Headers: $headers');
      if (body != null) {
        print('Body: $body');
      }
      print('===============================================================');
    }

    try {
      final response = await requestFn().timeout(const Duration(seconds: 15));

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

  Future<List<MaintenanceTicketModel>> getTickets({
    required String token,
    String status = 'open',
    String search = '',
    int page = 1,
    int perPage = 20,
  }) async {
    final uri = Uri.parse('${AppConstants.baseUrl}/api/v1/tickets').replace(
      queryParameters: {
        'status': status,
        'search': search,
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
    final headers = {'Authorization': 'Bearer $token', 'Accept': 'application/json'};

    final response = await _safeRequest(
      "GET_TICKETS",
      uri.toString(),
      headers,
          () => http.get(uri, headers: headers),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<dynamic> tickets = json['data']['tickets'];
      return tickets.map((t) => MaintenanceTicketModel.fromJson(t)).toList();
    } else {
      throw Exception("فشل جلب الطلبات (رمز الخطأ: ${response.statusCode})");
    }
  }

  Future<void> createTicket({
    required String token,
    required String subject,
    required String description,
    required int unitId,
    required int categoryId,
    required String priority,
    required List<File> images,
  }) async {
    final url = '${AppConstants.baseUrl}/api/user/new_ticket';
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    List<Map<String, dynamic>> imagesList = [];
    for (var imageFile in images) {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final fileName = imageFile.path.split('/').last;
      String mimeType = "image/jpeg";
      if (fileName.toLowerCase().endsWith('.png')) {
        mimeType = "image/png";
      } else if (fileName.toLowerCase().endsWith('.jpg') || fileName.toLowerCase().endsWith('.jpeg')) {
        mimeType = "image/jpeg";
      }

      imagesList.add({
        "image": base64Image,
        "filename": fileName,
        "mimetype": mimeType,
        "image_type": "before",
        "note": "صورة توضيحية للمشكلة"
      });
    }

    final requestBody = jsonEncode({
      "title": subject,
      "description": description,
      "category_id": categoryId,
      "unit_id": unitId,
      "priority": priority,
      "images": imagesList,
    });

    final response = await _safeRequest(
      "CREATE_TICKET_JSON",
      url,
      headers,
          () => http.post(Uri.parse(url), headers: headers, body: requestBody),
      body: requestBody,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("فشل إنشاء الطلب: ${response.body}");
    }
  }

  Future<void> rateTicket({
    required String token,
    required int ticketId,
    required int rating,
    required String feedback,
  }) async {
    final url = '${AppConstants.baseUrl}/api/user/rate_ticket';
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    final requestBody = jsonEncode({
      "ticket_id": ticketId,
      "rating": rating,
      "feedback": feedback,
    });

    final response = await _safeRequest(
      "RATE_TICKET",
      url,
      headers,
          () => http.post(Uri.parse(url), headers: headers, body: requestBody),
      body: requestBody,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("فشل إرسال التقييم: ${response.body}");
    }
  }

  Future<List<StatusModel>> getTicketStatuses(String token) async {
    final url = '${AppConstants.baseUrl}/api/user/Tickets_status';
    final headers = {'Authorization': 'Bearer $token', 'Accept': 'application/json'};

    final response = await _safeRequest(
      "GET_TICKET_STATUSES",
      url,
      headers,
          () => http.get(Uri.parse(url), headers: headers),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data']['statuses'];
      List<StatusModel> statuses = data.map((e) => StatusModel.fromJson(e)).toList();
      statuses.sort((a, b) => a.sequence.compareTo(b.sequence));
      return statuses;
    }
    throw Exception("فشل جلب الحالات (رمز الخطأ: ${response.statusCode})");
  }

  Future<List<MaintenanceCategoryModel>> getCategories(String token) async {
    final url = '${AppConstants.baseUrl}/api/v1/maintenance/categories';
    final headers = {'Authorization': 'Bearer $token', 'Accept': 'application/json'};

    final response = await _safeRequest(
      "GET_CATEGORIES",
      url,
      headers,
          () => http.get(Uri.parse(url), headers: headers),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List data = jsonResponse['data']['categories'] ?? [];
      return data.map((e) => MaintenanceCategoryModel.fromJson(e)).toList();
    } else {
      throw Exception("فشل جلب الفئات (رمز الخطأ: ${response.statusCode})");
    }
  }

  Future<List<PriorityModel>> getPriorities(String token) async {
    final url = '${AppConstants.baseUrl}/api/v1/maintenance/priorities';
    final headers = {'Authorization': 'Bearer $token', 'Accept': 'application/json'};

    final response = await _safeRequest(
      "GET_PRIORITIES",
      url,
      headers,
          () => http.get(Uri.parse(url), headers: headers),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final List data = jsonResponse['data']['priorities'] ?? [];
      return data.map((e) => PriorityModel.fromJson(e)).toList();
    } else {
      throw Exception("فشل جلب الأولويات (رمز الخطأ: ${response.statusCode})");
    }
  }
}
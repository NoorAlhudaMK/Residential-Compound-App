import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Core/AppConstants/app_constants.dart';
import '../../Core/CacheManager/cache_manager.dart';
import '../Models/payment_model.dart';

class PaymentsRepository {
  Future<PaymentsResponseModel> getPayments({
    int page = 1,
    int perPage = 20,
    String status = 'all',
  }) async {
    final token = await CacheManager.getToken();
    final url = Uri.parse(
      '${AppConstants.baseUrl}/api/v1/payments?status=$status&page=$page&per_page=$perPage',
    );

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      return PaymentsResponseModel.fromJson(jsonBody);
    } else {
      throw Exception('فشل في جلب المدفوعات: ${response.statusCode}');
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Core/AppConstants/app_constants.dart';
import '../Models/dashboard_data_model.dart';

class HomeRepository {
  Future<DashboardDataModel> getHomeData(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/v1/resident/home'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return DashboardDataModel.fromJson(json['data']);
    }
    throw Exception("فشل جلب البيانات");
  }
}

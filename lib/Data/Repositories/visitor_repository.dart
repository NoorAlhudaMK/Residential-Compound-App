import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Core/AppConstants/app_constants.dart';
import '../Models/visitor_model.dart';

class VisitorRepository {
  Future<List<VisitorModel>> getVisitors(String token) async {

    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/get_visitor'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
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
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/user/add_new_visitor'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "visitor_name": name,
        "visitor_phone": phone,
        "unit_id": unitId,
        "valid_from": validFrom,
        "valid_to": validTo,
        "has_car": hasCar,
        "car_plate": carPlate,
        "resident_id": residentId,
      }),
    );

    print("Response Body: ${response.body}");

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
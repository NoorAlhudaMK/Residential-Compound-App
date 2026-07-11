import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Core/AppConstants/app_constants.dart';
import '../Models/notification_model.dart';

class NotificationRepository {

  Future<List<NotificationModel>> fetchNotifications(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/notifications'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body)['data']['notifications'];
      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}
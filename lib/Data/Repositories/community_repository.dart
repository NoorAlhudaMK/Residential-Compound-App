import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Core/AppConstants/app_constants.dart';
import '../Models/announcement_model.dart';

class CommunityRepository {
  Future<List<AnnouncementModel>> fetchAnnouncements(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/ads_banner'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> banners = body['data']['banners'];
      return banners.map((json) => AnnouncementModel.fromJson(json)).toList();
    } else {
      throw Exception("فشل جلب الإعلانات");
    }
  }
}
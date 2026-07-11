import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Core/AppConstants/app_constants.dart';
import '../Models/maintenance_ticket_model.dart';
import '../Models/status_model.dart';

class MaintenanceRepository {
  Future<List<MaintenanceTicketModel>> getTickets(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/tickets'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<dynamic> tickets = json['data']['tickets'];
      return tickets.map((t) => MaintenanceTicketModel.fromJson(t)).toList();
    } else {
      throw Exception("فشل جلب الطلبات");
    }
  }

  Future<void> createTicket({
    required String token,
    required String subject,
    required String description,
    required int unitId,
    required int categoryId,
    required String priority,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/user/new_ticket'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "subject": subject,
        "description": description,
        "unit_id": unitId,
        "category_id": categoryId,
        "priority": priority,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("فشل إنشاء الطلب");
    }
  }

  Future<void> rateTicket({
    required String token,
    required int ticketId,
    required int rating,
    required String feedback,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/api/user/rate_ticket'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "ticket_id": ticketId,
        "rating": rating,
        "feedback": feedback,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("فشل إرسال التقييم: ${response.body}");
    }
  }

  Future<List<StatusModel>> getTicketStatuses(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/Tickets_status'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data']['statuses'];
      List<StatusModel> statuses = data.map((e) => StatusModel.fromJson(e)).toList();
      statuses.sort((a, b) => a.sequence.compareTo(b.sequence));
      return statuses;
    }
    throw Exception("فشل جلب الحالات");
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Core/AppConstants/app_constants.dart';
import '../Models/invoice_model.dart';

class BillingRepository {
  // جلب كل الفواتير وفلترة المستحقة فقط
  Future<List<InvoiceModel>> fetchUnpaidInvoices(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/v1/invoices'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> invoices = body['data']['invoices'];

      return invoices
          .map((json) => InvoiceModel.fromJson(json))
          .where((invoice) => invoice.paymentState == 'not_paid')
          .toList();
    } else {
      throw Exception("فشل جلب الفواتير المستحقة");
    }
  }

  // جلب كل الفواتير وفلترة المدفوعة لتاب "مدفوعة"
  Future<List<InvoiceModel>> fetchPaidInvoices(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/v1/invoices'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> invoices = body['data']['invoices'];

      return invoices
          .map((json) => InvoiceModel.fromJson(json))
          .where((invoice) => invoice.paymentState == 'paid')
          .toList();
    } else {
      throw Exception("فشل جلب الفواتير المدفوعة");
    }
  }
}
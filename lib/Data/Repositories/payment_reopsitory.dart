import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Core/AppConstants/app_constants.dart';
import '../Models/payment_model.dart';
import '../Models/invoice_model.dart'; // تأكد من استيراد مودل الفواتير

class PaymentRepository {

  Future<List<PaymentModel>> fetchPaidBills(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/payments'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      final List<dynamic> payments = body['data']['payments'];
      return payments.map((json) => PaymentModel.fromJson(json)).toList();
    } else {
      throw Exception("فشل جلب المدفوعات");
    }
  }

  Future<List<InvoiceModel>> fetchUnpaidInvoices(String token) async {
    final response = await http.get(
      Uri.parse('${AppConstants.baseUrl}/api/user/invoices'),
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
}
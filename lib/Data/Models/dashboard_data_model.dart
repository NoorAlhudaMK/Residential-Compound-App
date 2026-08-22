import 'package:residential_compound_app/Data/Models/recent_invoices_model.dart';
import 'package:residential_compound_app/Data/Models/recent_visitors_model.dart';

class DashboardDataModel {
  final double amountDue;
  final List<InvoiceModel> recentInvoices;
  final List<VisitorModel> recentVisitors;

  DashboardDataModel({
    required this.amountDue,
    required this.recentInvoices,
    required this.recentVisitors,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) {
    return DashboardDataModel(
      amountDue: json['amount_due'] != null ? (json['amount_due'] as num).toDouble() : 0.0,

      recentInvoices: json['recent_invoices'] != null
          ? (json['recent_invoices'] as List)
          .map((i) => InvoiceModel.fromJson(i))
          .toList()
          : [],

      recentVisitors: json['recent_visitors'] != null
          ? (json['recent_visitors'] as List)
          .map((i) => VisitorModel.fromJson(i))
          .toList()
          : [],
    );
  }
}
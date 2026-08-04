class PaymentsResponseModel {
  final bool success;
  final String message;
  final PaymentsDataModel data;

  PaymentsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaymentsResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentsResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: PaymentsDataModel.fromJson(json['data'] ?? {}),
    );
  }
}

class PaymentsDataModel {
  final List<PaymentModel> payments;
  final List<PaymentRequestModel> paymentRequests;
  final PaginationModel pagination;
  final SummaryModel summary;

  PaymentsDataModel({
    required this.payments,
    required this.paymentRequests,
    required this.pagination,
    required this.summary,
  });

  factory PaymentsDataModel.fromJson(Map<String, dynamic> json) {
    return PaymentsDataModel(
      payments: (json['payments'] as List? ?? [])
          .map((e) => PaymentModel.fromJson(e))
          .toList(),
      paymentRequests: (json['payment_requests'] as List? ?? [])
          .map((e) => PaymentRequestModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
      summary: SummaryModel.fromJson(json['summary'] ?? {}),
    );
  }
}

class PaymentModel {
  final int id;
  final int paymentId;
  final String name;
  final double amount;
  final String currency;
  final String date;
  final String state;

  PaymentModel({
    required this.id,
    required this.paymentId,
    required this.name,
    required this.amount,
    required this.currency,
    required this.date,
    required this.state,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? 0,
      paymentId: json['payment_id'] ?? 0,
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'IQD',
      date: json['date'] ?? '',
      state: json['state'] ?? '',
    );
  }
}

class PaymentRequestModel {
  final int id;
  final int paymentRequestId;
  final int invoiceId;
  final double amount;
  final String currency;
  final String state;
  final String portalUrl;

  PaymentRequestModel({
    required this.id,
    required this.paymentRequestId,
    required this.invoiceId,
    required this.amount,
    required this.currency,
    required this.state,
    required this.portalUrl,
  });

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestModel(
      id: json['id'] ?? 0,
      paymentRequestId: json['payment_request_id'] ?? 0,
      invoiceId: json['invoice_id'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'IQD',
      state: json['state'] ?? '',
      portalUrl: json['portal_url'] ?? '',
    );
  }
}

class PaginationModel {
  final int page;
  final int perPage;
  final int total;
  final int pages;
  final bool hasNext;

  PaginationModel({
    required this.page,
    required this.perPage,
    required this.total,
    required this.pages,
    required this.hasNext,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      total: json['total'] ?? 0,
      pages: json['pages'] ?? 1,
      hasNext: json['has_next'] ?? false,
    );
  }
}

class SummaryModel {
  final int totalPayments;
  final double totalPaid;

  SummaryModel({
    required this.totalPayments,
    required this.totalPaid,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      totalPayments: json['total_payments'] ?? 0,
      totalPaid: (json['total_paid'] ?? 0).toDouble(),
    );
  }
}
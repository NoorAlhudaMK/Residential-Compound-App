class InvoiceModel {
  final int id;
  final String name;
  final String dueDate;
  final double amountTotal;
  final String paymentState;

  InvoiceModel({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.amountTotal,
    required this.paymentState,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      dueDate: json['due_date'] ?? '',
      amountTotal: (json['amount_total'] ?? 0.0).toDouble(),
      paymentState: json['payment_state'] ?? 'not_paid',
    );
  }
}
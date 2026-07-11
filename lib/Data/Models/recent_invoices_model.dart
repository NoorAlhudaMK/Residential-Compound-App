class InvoiceModel {
  final int id;
  final String name;
  final String invoiceDate;
  final String dueDate;
  final double amountTotal;
  final String paymentState;

  InvoiceModel({
    required this.id, required this.name, required this.invoiceDate,
    required this.dueDate, required this.amountTotal, required this.paymentState,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      name: json['name'],
      invoiceDate: json['invoice_date'],
      dueDate: json['due_date'],
      amountTotal: (json['amount_total'] as num).toDouble(),
      paymentState: json['payment_state'],
    );
  }
}
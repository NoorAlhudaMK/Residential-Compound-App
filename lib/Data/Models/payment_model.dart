class PaymentModel {
  final int id;
  final String name;
  final double amount;
  final String currency;
  final String paymentDate;
  final String state;

  PaymentModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.paymentDate,
    required this.state,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      paymentDate: json['payment_date'] ?? '',
      state: json['state'] ?? '',
    );
  }
}
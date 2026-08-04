import '../../../Data/Models/payment_model.dart';

abstract class PaymentsState {}

class PaymentsInitial extends PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentsLoaded extends PaymentsState {
  final List<PaymentModel> payments;
  final List<PaymentRequestModel> paymentRequests;
  final SummaryModel summary;
  final bool hasMore;
  final bool isLoadingMore;

  PaymentsLoaded({
    required this.payments,
    required this.paymentRequests,
    required this.summary,
    required this.hasMore,
    required this.isLoadingMore,
  });

  PaymentsLoaded copyWith({
    List<PaymentModel>? payments,
    List<PaymentRequestModel>? paymentRequests,
    SummaryModel? summary,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return PaymentsLoaded(
      payments: payments ?? this.payments,
      paymentRequests: paymentRequests ?? this.paymentRequests,
      summary: summary ?? this.summary,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class PaymentsError extends PaymentsState {
  final String message;
  PaymentsError(this.message);
}
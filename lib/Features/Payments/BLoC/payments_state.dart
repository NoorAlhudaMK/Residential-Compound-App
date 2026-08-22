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
  final String selectedStatus;

  PaymentsLoaded({
    required this.payments,
    required this.paymentRequests,
    required this.summary,
    required this.hasMore,
    required this.isLoadingMore,
    required this.selectedStatus,
  });

  PaymentsLoaded copyWith({
    List<PaymentModel>? payments,
    List<PaymentRequestModel>? paymentRequests,
    SummaryModel? summary,
    bool? hasMore,
    bool? isLoadingMore,
    String? selectedStatus,
  }) {
    return PaymentsLoaded(
      payments: payments ?? this.payments,
      paymentRequests: paymentRequests ?? this.paymentRequests,
      summary: summary ?? this.summary,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}

class PaymentsError extends PaymentsState {
  final String message;
  PaymentsError(this.message);
}
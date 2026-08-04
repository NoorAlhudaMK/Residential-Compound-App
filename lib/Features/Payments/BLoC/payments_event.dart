abstract class PaymentsEvent {}

class FetchPaymentsEvent extends PaymentsEvent {
  final bool isRefresh;
  final String status;

  FetchPaymentsEvent({this.isRefresh = false, this.status = 'all'});
}

class LoadMorePaymentsEvent extends PaymentsEvent {}
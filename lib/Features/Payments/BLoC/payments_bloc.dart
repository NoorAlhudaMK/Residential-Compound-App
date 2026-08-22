import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Repositories/payment_reopsitory.dart';
import 'payments_event.dart';
import 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final PaymentsRepository repository;
  int _currentPage = 1;
  bool _hasNextPage = true;
  String _currentStatus = 'all';

  PaymentsBloc({required this.repository}) : super(PaymentsInitial()) {
    on<FetchPaymentsEvent>(_onFetchPayments);
    on<LoadMorePaymentsEvent>(_onLoadMorePayments);
  }

  Future<void> _onFetchPayments(
      FetchPaymentsEvent event,
      Emitter<PaymentsState> emit,
      ) async {
    if (event.isRefresh) {
      _currentPage = 1;
      _hasNextPage = true;
    }
    _currentStatus = event.status;

    if (_currentPage == 1) {
      emit(PaymentsLoading());
    }

    try {
      final response = await repository.getPayments(
        page: _currentPage,
        status: _currentStatus,
      );

      _hasNextPage = response.data.pagination.hasNext;

      emit(PaymentsLoaded(
        payments: response.data.payments,
        paymentRequests: response.data.paymentRequests,
        summary: response.data.summary,
        hasMore: _hasNextPage,
        isLoadingMore: false,
        selectedStatus: _currentStatus,
      ));
    } catch (e) {
      emit(PaymentsError(e.toString()));
    }
  }

  Future<void> _onLoadMorePayments(
      LoadMorePaymentsEvent event,
      Emitter<PaymentsState> emit,
      ) async {
    if (!_hasNextPage) return;
    if (state is PaymentsLoaded) {
      final currentState = state as PaymentsLoaded;
      if (currentState.isLoadingMore) return;

      emit(currentState.copyWith(isLoadingMore: true));

      try {
        _currentPage++;
        final response = await repository.getPayments(
          page: _currentPage,
          status: _currentStatus,
        );

        _hasNextPage = response.data.pagination.hasNext;

        emit(PaymentsLoaded(
          payments: [...currentState.payments, ...response.data.payments],
          paymentRequests: [...currentState.paymentRequests, ...response.data.paymentRequests],
          summary: response.data.summary,
          hasMore: _hasNextPage,
          isLoadingMore: false,
          selectedStatus: 'all'
        ));
      } catch (e) {
        _currentPage--;
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }
}
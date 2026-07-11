import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Data/Repositories/payment_reopsitory.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Data/Models/invoice_model.dart';
import '../../../Data/Models/payment_model.dart';
import 'billing_event.dart';
import 'billing_state.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  final PaymentRepository repository;

  BillingBloc({required this.repository}) : super(BillingState()) {

    on<LoadBills>((event, emit) async {
      emit(state.copyWith(status: BillingStatus.loading));
      try {
        final token = await CacheManager.getToken();

        final results = await Future.wait([
          repository.fetchUnpaidInvoices(token!),
          repository.fetchPaidBills(token),
        ]);

        emit(state.copyWith(
          status: BillingStatus.success,
          bills: results[0] as List<InvoiceModel>, // المستحقة
          paidBills: results[1] as List<PaymentModel>, // المدفوعة
        ));
      } catch (e) {
        emit(state.copyWith(status: BillingStatus.failure));
      }
    });

    on<ChangeTab>((event, emit) {
      emit(state.copyWith(selectedTab: event.index));
    });

    on<ToggleBillSelection>((event, emit) {
      final updatedSelection = Set<String>.from(state.selectedBillIds);
      if (updatedSelection.contains(event.billId)) {
        updatedSelection.remove(event.billId);
      } else {
        updatedSelection.add(event.billId);
      }
      emit(state.copyWith(selectedBillIds: updatedSelection));
    });

    on<SelectAllBills>((event, emit) {
      if (event.isSelected) {
        final allIds = state.bills.map((b) => b.id as String).toSet();
        emit(state.copyWith(selectedBillIds: allIds));
      } else {
        emit(state.copyWith(selectedBillIds: {}));
      }
    });
  }
}
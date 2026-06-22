import 'package:flutter_bloc/flutter_bloc.dart';
import 'billing_event.dart';
import 'billing_state.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  BillingBloc() : super(BillingState()) {

    on<LoadBills>((event, emit) async {
      emit(state.copyWith(status: BillingStatus.loading));
      await Future.delayed(const Duration(seconds: 1));

      final mockBills = [
        {'id': '1', 'title': 'الكهرباء', 'amount': 45000, 'date': 'أكتوبر 2026', 'status': 'خلال 4 أيام', 'icon': 0xe232, 'color': 0xFFFFB300},
        {'id': '2', 'title': 'الصيانة المشتركة', 'amount': 50000, 'date': 'أكتوبر 2026', 'status': 'متأخرة 1 يوم', 'icon': 0xe121, 'color': 0xFFFF5722},
        {'id': '3', 'title': 'المياه', 'amount': 12000, 'date': 'أكتوبر 2026', 'status': 'خلال 9 أيام', 'icon': 0xe6e4, 'color': 0xFF2196F3},
        {'id': '4', 'title': 'أجور التطبيق', 'amount': 20000, 'date': 'أكتوبر 2026', 'status': 'خلال 5 أيام', 'icon': 0xe6b9, 'color': 0xFF4CAF50},
      ];

      final mockPaidBills = [
        {'id': 'p1', 'title': 'فاتورة المياه', 'amount': 120000, 'date': 'سبتمبر 2026', 'paidDate': 'تم الدفع في 5 سبتمبر', 'icon': 0xe6e4, 'color': 0xFF4CAF50},
      ];

      emit(state.copyWith(
        status: BillingStatus.success,
        bills: mockBills,
        paidBills: mockPaidBills,
        totalDue: 127000,
        selectedBillIds: {'1', '2'},
      ));
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
        final allIds = state.bills.map((b) => b['id'] as String).toSet();
        emit(state.copyWith(selectedBillIds: allIds));
      } else {
        emit(state.copyWith(selectedBillIds: {}));
      }
    });
  }
}
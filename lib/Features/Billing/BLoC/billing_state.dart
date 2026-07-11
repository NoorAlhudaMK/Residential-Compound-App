import '../../../Data/Models/invoice_model.dart';
import '../../../Data/Models/payment_model.dart';

enum BillingStatus { initial, loading, success, failure }

class BillingState {
  late final List<InvoiceModel> bills; // الفواتير المستحقة
  final List<PaymentModel> paidBills; // الفواتير المدفوعة
  late final Set<String> selectedBillIds;
  final BillingStatus status;
  final double totalDue;
  final int selectedTab; // 0 للمستحقة، 1 للمدفوعة

  BillingState({
    this.bills = const [],
    this.paidBills = const [],
    this.selectedBillIds = const {},
    this.status = BillingStatus.initial,
    this.totalDue = 0.0,
    this.selectedTab = 0,
  });

  double get selectedTotal {
    return bills
        .where((bill) => selectedBillIds.contains(bill.id.toString()))
        .fold(0.0, (sum, bill) => sum + bill.amountTotal);
  }

  double get totalUnpaidAmount => bills.fold(0.0, (sum, bill) => sum + bill.amountTotal);

  BillingState copyWith({
    List<InvoiceModel>? bills,
    List<PaymentModel>? paidBills,
    Set<String>? selectedBillIds,
    BillingStatus? status,
    double? totalDue,
    int? selectedTab,
  }) {
    return BillingState(
      bills: bills ?? this.bills,
      paidBills: paidBills ?? this.paidBills,
      selectedBillIds: selectedBillIds ?? this.selectedBillIds,
      status: status ?? this.status,
      totalDue: totalDue ?? this.totalDue,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

enum BillingStatus { initial, loading, success, failure }

class BillingState {
  final List<Map<String, dynamic>> bills; // الفواتير المستحقة
  final List<Map<String, dynamic>> paidBills; // الفواتير المدفوعة
  final Set<String> selectedBillIds;
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
        .where((bill) => selectedBillIds.contains(bill['id']))
        .fold(0.0, (sum, bill) => sum + bill['amount']);
  }

  BillingState copyWith({
    List<Map<String, dynamic>>? bills,
    List<Map<String, dynamic>>? paidBills,
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
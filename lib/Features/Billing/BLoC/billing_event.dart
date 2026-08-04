abstract class BillingEvent {}

class LoadBills extends BillingEvent {}

class ToggleBillSelection extends BillingEvent {
  final String billId;
  ToggleBillSelection(this.billId);
}

class ChangeTab extends BillingEvent {
  final int index;
  ChangeTab(this.index);
}

class SelectAllBills extends BillingEvent {
  final bool isSelected;
  SelectAllBills(this.isSelected);
}
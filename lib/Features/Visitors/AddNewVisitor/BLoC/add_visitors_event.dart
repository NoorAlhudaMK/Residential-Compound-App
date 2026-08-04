abstract class AddVisitorEvent {}

class NextStepEvent extends AddVisitorEvent {}

class PreviousStepEvent extends AddVisitorEvent {}

class CreateVisitor extends AddVisitorEvent {
  final String name;
  final String phone;
  final int unitId;
  final String validTo;
  final String validFrom;
  final bool hasCar;
  final String carPlate;

  CreateVisitor({
    required this.name,
    required this.phone,
    required this.unitId,
    required this.validFrom,
    required this.validTo,
    required this.hasCar,
    required this.carPlate,
  });
}

class UpdateHasCar extends AddVisitorEvent {
  final bool value;
  UpdateHasCar(this.value);
}

class UpdateDate extends AddVisitorEvent {
  final DateTime date;
  UpdateDate(this.date);
}

class UpdateIsTimeSelected extends AddVisitorEvent {
  final bool isSelected;
  UpdateIsTimeSelected(this.isSelected);
}
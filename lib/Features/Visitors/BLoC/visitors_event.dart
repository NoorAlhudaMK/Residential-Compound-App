abstract class VisitorEvent {}

class ToggleTab extends VisitorEvent {
  final int index;
  ToggleTab(this.index);
}

class FetchVisitors extends VisitorEvent {}

class CreateVisitor extends VisitorEvent {
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

class UpdateHasCar extends VisitorEvent {
  final bool value;
  UpdateHasCar(this.value);
}

class UpdateCompanions extends VisitorEvent {
  final int count;
  UpdateCompanions(this.count);
}

class UpdateDate extends VisitorEvent {
  final DateTime date;
  UpdateDate(this.date);
}

class UpdateRelation extends VisitorEvent {
  final String relation;
  UpdateRelation(this.relation);
}

class ResetForm extends VisitorEvent {}

import 'dart:io';

abstract class AddMaintenanceEvent {}

class NextStepEvent extends AddMaintenanceEvent {}

class PreviousStepEvent extends AddMaintenanceEvent {}

class LoadCategoriesEvent extends AddMaintenanceEvent {}

class SelectCategory extends AddMaintenanceEvent {
  final int categoryId;
  SelectCategory(this.categoryId);
}

class UpdateDescriptionText extends AddMaintenanceEvent {
  final String text;
  UpdateDescriptionText(this.text);
}

class SelectPriority extends AddMaintenanceEvent {
  final String priority;
  SelectPriority(this.priority);
}

class AddImage extends AddMaintenanceEvent {
  final File image;
  AddImage(this.image);
}

class RemoveImage extends AddMaintenanceEvent {
  final int index;
  RemoveImage(this.index);
}

class SubmitTicket extends AddMaintenanceEvent {
  final String subject;
  final String description;
  SubmitTicket({required this.subject, required this.description});
}
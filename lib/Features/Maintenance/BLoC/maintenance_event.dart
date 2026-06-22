import 'dart:io';

abstract class MaintenanceEvent {}

class LoadMaintenanceData extends MaintenanceEvent {}

class SelectService extends MaintenanceEvent {
  final String service;
  SelectService(this.service);
}

class UpdateDescription extends MaintenanceEvent {
  final int length;
  UpdateDescription(this.length);
}

class AddImage extends MaintenanceEvent {
  final File image;
  AddImage(this.image);
}

class RemoveImage extends MaintenanceEvent {
  final int index;
  RemoveImage(this.index);
}

class UpdateRating extends MaintenanceEvent {
  final int rating;
  UpdateRating(this.rating);
}

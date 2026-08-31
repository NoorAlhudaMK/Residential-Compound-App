import 'dart:io';

abstract class MaintenanceEvent {}

class LoadMaintenanceData extends MaintenanceEvent {
  final String? status;
  final int? page;
  final bool isPagination;

  LoadMaintenanceData({this.status, this.page, this.isPagination = false});
}

class SearchMaintenance extends MaintenanceEvent {
  final String query;
  SearchMaintenance(this.query);
}

class LoadCategoriesEvent extends MaintenanceEvent {}

class SelectCategory extends MaintenanceEvent {
  final int categoryId;
  SelectCategory(this.categoryId);
}

// --- الأحداث الأخرى (الإنشاء، التقييم، الخطوات) ---
class NextStepEvent extends MaintenanceEvent {}

class PreviousStepEvent extends MaintenanceEvent {}

class SelectService extends MaintenanceEvent {
  final String service;
  SelectService(this.service);
}

class UpdateDescriptionText extends MaintenanceEvent {
  final String text;
  UpdateDescriptionText(this.text);
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

class SubmitTicket extends MaintenanceEvent {
  final String subject;
  final String description;
  SubmitTicket({required this.subject, required this.description});
}

class RateTicket extends MaintenanceEvent {
  final int ticketId;
  final int rating;
  final String feedback;

  RateTicket({
    required this.ticketId,
    required this.rating,
    required this.feedback,
  });
}

import 'dart:io';
import '../../../Data/Models/maintenance_ticket_model.dart';
import '../../../Data/Models/status_model.dart';

class MaintenanceState {
  final List<MaintenanceTicketModel> activeRequests;
  final List<MaintenanceTicketModel> pastRequests;
  final List<StatusModel> statuses;
  final String descriptionText;
  final bool isLoading;
  final int rating;
  final List<File> selectedImages;
  final String selectedService;
  final int descriptionLength;

  MaintenanceState({
    this.activeRequests = const [],
    this.pastRequests = const [],
    this.statuses = const [],
    this.descriptionText = "",
    this.isLoading = false,
    this.selectedImages = const [],
    this.selectedService = "كهرباء",
    this.descriptionLength = 0,
    this.rating = 0,
  });

  MaintenanceState copyWith({
    List<MaintenanceTicketModel>? activeRequests,
    List<MaintenanceTicketModel>? pastRequests,
    List<StatusModel>? statuses,
    String? descriptionText,
    bool? isLoading,
    List<File>? selectedImages,
    String? selectedService,
    int? descriptionLength,
    int? rating,
  }) {
    return MaintenanceState(
      activeRequests: activeRequests ?? this.activeRequests,
      pastRequests: pastRequests ?? this.pastRequests,
      descriptionText: descriptionText ?? this.descriptionText,
      statuses: statuses ?? this.statuses,
      isLoading: isLoading ?? this.isLoading,
      selectedImages: selectedImages ?? this.selectedImages,
      selectedService: selectedService ?? this.selectedService,
      descriptionLength: descriptionLength ?? this.descriptionLength,
      rating: rating ?? this.rating,
    );
  }
}
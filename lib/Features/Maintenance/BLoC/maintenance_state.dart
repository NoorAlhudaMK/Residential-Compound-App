import 'dart:io';

class MaintenanceState {
  final List<Map<String, dynamic>> activeRequests;
  final List<Map<String, dynamic>> pastRequests;
  final bool isLoading;
  final int rating;

  // الحقول الجديدة
  final List<File> selectedImages;
  final String selectedService;
  final int descriptionLength;

  MaintenanceState({
    this.activeRequests = const [],
    this.pastRequests = const [],
    this.isLoading = false,
    this.selectedImages = const [],
    this.selectedService = "كهرباء",
    this.descriptionLength = 0,
    this.rating = 0,
  });

  // دالة copyWith لتحديث الـ State
  MaintenanceState copyWith({
    List<Map<String, dynamic>>? activeRequests,
    List<Map<String, dynamic>>? pastRequests,
    bool? isLoading,
    List<File>? selectedImages,
    String? selectedService,
    int? descriptionLength,
    int? rating,
  }) {
    return MaintenanceState(
      activeRequests: activeRequests ?? this.activeRequests,
      pastRequests: pastRequests ?? this.pastRequests,
      isLoading: isLoading ?? this.isLoading,
      selectedImages: selectedImages ?? this.selectedImages,
      selectedService: selectedService ?? this.selectedService,
      descriptionLength: descriptionLength ?? this.descriptionLength,
      rating: rating ?? this.rating,
    );
  }
}
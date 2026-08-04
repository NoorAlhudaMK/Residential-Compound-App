import 'dart:io';

import '../../../../Data/Models/maintenance_category_model.dart';

class AddMaintenanceState {
  final int currentStep;
  final bool isLoading;
  final String descriptionText;

  final List<MaintenanceCategoryModel> categories;
  final int? selectedCategoryId;
  final String selectedPriority;

  final List<File> selectedImages;
  final String? errorMessage;

  AddMaintenanceState({
    this.currentStep = 1,
    this.isLoading = false,
    this.descriptionText = "",
    this.categories = const [],
    this.selectedCategoryId,
    this.selectedPriority = "2",
    this.selectedImages = const [],
    this.errorMessage,
  });

  AddMaintenanceState copyWith({
    int? currentStep,
    bool? isLoading,
    String? descriptionText,
    List<MaintenanceCategoryModel>? categories,
    int? selectedCategoryId,
    String? selectedPriority,
    List<File>? selectedImages,
    String? errorMessage,
  }) {
    return AddMaintenanceState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      descriptionText: descriptionText ?? this.descriptionText,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      selectedImages: selectedImages ?? this.selectedImages,
      errorMessage: errorMessage,
    );
  }
}
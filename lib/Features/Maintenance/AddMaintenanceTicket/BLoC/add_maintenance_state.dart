import 'dart:io';
import '../../../../Data/Models/maintenance_category_model.dart';
import '../../../../Data/Models/priority_model.dart';

class AddMaintenanceState {
  final int currentStep;
  final bool isLoading;
  final String titleText; // حقل العنوان الجديد
  final String descriptionText;

  final List<MaintenanceCategoryModel> categories;
  final List<PriorityModel> priorities;

  final int? selectedCategoryId;
  final String selectedPriority;

  final List<File> selectedImages;
  final String? errorMessage;
  final bool isSuccess;

  const AddMaintenanceState({
    this.currentStep = 1,
    this.isLoading = false,
    this.titleText = "", // القيمة الافتراضية فارغة
    this.descriptionText = "",
    this.categories = const [],
    this.priorities = const [],
    this.selectedCategoryId,
    this.selectedPriority = "2",
    this.selectedImages = const [],
    this.errorMessage,
    this.isSuccess = false,
  });

  AddMaintenanceState copyWith({
    int? currentStep,
    bool? isLoading,
    String? titleText, // تمرير العنوان
    String? descriptionText,
    List<MaintenanceCategoryModel>? categories,
    List<PriorityModel>? priorities,
    int? selectedCategoryId,
    String? selectedPriority,
    List<File>? selectedImages,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AddMaintenanceState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      titleText: titleText ?? this.titleText, // تحديث العنوان
      descriptionText: descriptionText ?? this.descriptionText,
      categories: categories ?? this.categories,
      priorities: priorities ?? this.priorities,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedPriority: selectedPriority ?? this.selectedPriority,
      selectedImages: selectedImages ?? this.selectedImages,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
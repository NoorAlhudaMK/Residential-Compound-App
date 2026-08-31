import 'dart:io';
import '../../../../Data/Models/maintenance_category_model.dart';
import '../../../../Data/Models/maintenance_ticket_model.dart';
import '../../../../Data/Models/status_model.dart';

class MaintenanceState {
  final List<MaintenanceTicketModel> tickets;
  final List<StatusModel> statuses;
  final bool isLoading;
  final bool isMoreLoading;
  final bool hasMore;
  final int currentPage;
  final String selectedStatusFilter;
  final String searchQuery;

  final int? selectedCategoryId;
  final List<MaintenanceCategoryModel> categories;

  final int currentStep;
  final String descriptionText;
  final int rating;
  final List<File> selectedImages;
  final String selectedService;
  final String? errorMessage;

  MaintenanceState({
    this.tickets = const [],
    this.statuses = const [],
    this.isLoading = false,
    this.isMoreLoading = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.selectedStatusFilter = 'open',
    this.searchQuery = '',
    this.selectedCategoryId,
    this.categories = const [],
    this.currentStep = 1,
    this.descriptionText = "",
    this.rating = 0,
    this.selectedImages = const [],
    this.selectedService = "",
    this.errorMessage,
  });

  MaintenanceState copyWith({
    List<MaintenanceTicketModel>? tickets,
    List<StatusModel>? statuses,
    bool? isLoading,
    bool? isMoreLoading,
    bool? hasMore,
    int? currentPage,
    String? selectedStatusFilter,
    String? searchQuery,
    int? selectedCategoryId,
    List<MaintenanceCategoryModel>? categories,
    int? currentStep,
    String? descriptionText,
    int? rating,
    List<File>? selectedImages,
    String? selectedService,
    String? errorMessage,
  }) {
    return MaintenanceState(
      tickets: tickets ?? this.tickets,
      statuses: statuses ?? this.statuses,
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      categories: categories ?? this.categories,
      currentStep: currentStep ?? this.currentStep,
      descriptionText: descriptionText ?? this.descriptionText,
      rating: rating ?? this.rating,
      selectedImages: selectedImages ?? this.selectedImages,
      selectedService: selectedService ?? this.selectedService,
      errorMessage: errorMessage,
    );
  }
}
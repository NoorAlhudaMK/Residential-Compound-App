import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/CacheManager/cache_manager.dart';
import '../../../../Data/Repositories/maintenance_repository.dart';
import 'add_maintenance_event.dart';
import 'add_maintenance_state.dart';

class AddMaintenanceBloc
    extends Bloc<AddMaintenanceEvent, AddMaintenanceState> {
  final MaintenanceRepository repository;

  AddMaintenanceBloc({required this.repository})
      : super(AddMaintenanceState()) {

    on<LoadCategoriesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final token = await CacheManager.getToken();

        final categoriesList = await repository.getCategories(token!);

        emit(state.copyWith(
          isLoading: false,
          categories: categoriesList,
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<NextStepEvent>((event, emit) {
      if (state.currentStep < 3) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<PreviousStepEvent>((event, emit) {
      if (state.currentStep > 1) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<SelectCategory>((event, emit) {
      emit(state.copyWith(selectedCategoryId: event.categoryId));
    });

    on<UpdateDescriptionText>((event, emit) {
      emit(state.copyWith(descriptionText: event.text));
    });

    on<SelectPriority>((event, emit) {
      emit(state.copyWith(selectedPriority: event.priority));
    });

    on<AddImage>((event, emit) {
      final newList = List<File>.from(state.selectedImages)..add(event.image);
      emit(state.copyWith(selectedImages: newList));
    });

    on<RemoveImage>((event, emit) {
      final newList = List<File>.from(state.selectedImages)
        ..removeAt(event.index);
      emit(state.copyWith(selectedImages: newList));
    });

    on<SubmitTicket>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final token = await CacheManager.getToken();
        await repository.createTicket(
          token: token!,
          subject: event.subject,
          description: event.description,
          unitId: 1,
          categoryId: state.selectedCategoryId ?? 1, // استخدام الفئة المختارة ديناميكياً
          priority: state.selectedPriority, // استخدام الأولوية المختارة ديناميكياً
        );
        emit(
          state.copyWith(
            isLoading: false,
            currentStep: 1,
            descriptionText: "",
            selectedCategoryId: null,
            selectedImages: [],
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });
  }
}
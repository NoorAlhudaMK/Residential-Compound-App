import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/CacheManager/cache_manager.dart';
import '../../../../Data/Models/maintenance_category_model.dart';
import '../../../../Data/Models/priority_model.dart';
import '../../../../Data/Repositories/maintenance_repository.dart';
import 'add_maintenance_event.dart';
import 'add_maintenance_state.dart';

class AddMaintenanceBloc
    extends Bloc<AddMaintenanceEvent, AddMaintenanceState> {
  final MaintenanceRepository repository;

  AddMaintenanceBloc({required this.repository})
      : super(const AddMaintenanceState()) {

    on<LoadInitialDataEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));
      try {
        final token = await CacheManager.getToken();
        if (token == null) throw Exception("التوكن غير متوفر، يرجى تسجيل الدخول مجدداً.");

        final results = await Future.wait([
          repository.getCategories(token),
          repository.getPriorities(token),
        ]);

        final categoriesList = results[0] as List<MaintenanceCategoryModel>;
        final prioritiesList = results[1] as List<PriorityModel>;

        emit(state.copyWith(
          isLoading: false,
          categories: categoriesList,
          priorities: prioritiesList,
          selectedCategoryId: categoriesList.isNotEmpty ? categoriesList.first.id : null,
          selectedPriority: prioritiesList.isNotEmpty ? prioritiesList.first.id.toString() : '',
          isSuccess: false,
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<LoadCategoriesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final token = await CacheManager.getToken();
        final categoriesList = await repository.getCategories(token!);
        emit(state.copyWith(isLoading: false, categories: categoriesList));
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
      final newList = List<File>.from(state.selectedImages)..removeAt(event.index);
      emit(state.copyWith(selectedImages: newList));
    });

    on<SubmitTicket>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null, isSuccess: false));
      try {
        final token = await CacheManager.getToken();
        if (token == null) throw Exception("التوكن غير متوفر.");

        await repository.createTicket(
          token: token,
          subject: event.subject,
          description: event.description,
          unitId: 1,
          categoryId: state.selectedCategoryId ?? 1, ///TODO: Bring the real ID 💡
          priority: state.selectedPriority ?? '',
          images: state.selectedImages,
        );

        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            currentStep: 1,
            titleText: "",
            descriptionText: "",
            selectedCategoryId: state.categories.isNotEmpty ? state.categories.first.id : null,
            selectedImages: [],
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString(), isSuccess: false));
      }
    });

    on<UpdateTitleText>((event, emit) {
      emit(state.copyWith(titleText: event.title));
    });
  }
}
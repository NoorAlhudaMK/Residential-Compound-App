import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/CacheManager/cache_manager.dart';
import '../../../../Data/Repositories/maintenance_repository.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final MaintenanceRepository repository;

  MaintenanceBloc({required this.repository})
    : super(MaintenanceState(isLoading: true)) {
    on<LoadMaintenanceData>(_onLoadMaintenanceData);
    on<SearchMaintenance>(_onSearchMaintenance);
    on<UpdateRating>(_onUpdateRating);
    on<RateTicket>(_onRateTicket);
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
    on<SelectService>(_onSelectService);
    on<UpdateDescriptionText>(_onUpdateDescriptionText);
    on<AddImage>(_onAddImage);
    on<RemoveImage>(_onRemoveImage);
    on<LoadCategoriesEvent>(_loadCategoriesEvent);
    on<SelectCategory>(_selectCategory);
  }

  Future<void> _onLoadMaintenanceData(
    LoadMaintenanceData event,
    Emitter<MaintenanceState> emit,
  ) async {
    final status = event.status ?? state.selectedStatusFilter;
    final page = event.page ?? (event.isPagination ? state.currentPage + 1 : 1);

    if (event.isPagination) {
      if (state.isMoreLoading || !state.hasMore) return;
      emit(state.copyWith(isMoreLoading: true, errorMessage: null));
    } else {
      emit(
        state.copyWith(
          isLoading: true,
          errorMessage: null,
          selectedStatusFilter: status,
          currentPage: 1,
        ),
      );
    }

    try {
      final token = await CacheManager.getToken();
      final newTickets = await repository.getTickets(
        token: token!,
        status: status == 'all' ? '' : status,
        search: state.searchQuery,
        page: page,
        perPage: 10,
      );

      final statuses = await repository.getTicketStatuses(token);

      final updatedTickets = event.isPagination
          ? [...state.tickets, ...newTickets]
          : newTickets;

      emit(
        state.copyWith(
          isLoading: false,
          isMoreLoading: false,
          tickets: updatedTickets,
          statuses: statuses,
          currentPage: page,
          hasMore: newTickets.isNotEmpty,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isMoreLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSearchMaintenance(
    SearchMaintenance event,
    Emitter<MaintenanceState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query, currentPage: 1));
    add(LoadMaintenanceData(page: 1));
  }

  void _onUpdateRating(UpdateRating event, Emitter<MaintenanceState> emit) {
    emit(state.copyWith(rating: event.rating));
  }

  Future<void> _onRateTicket(
    RateTicket event,
    Emitter<MaintenanceState> emit,
  ) async {
    try {
      final token = await CacheManager.getToken();
      await repository.rateTicket(
        token: token!,
        ticketId: event.ticketId,
        rating: event.rating,
        feedback: event.feedback,
      );
      add(LoadMaintenanceData(page: 1));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _loadCategoriesEvent(LoadCategoriesEvent event, Emitter<MaintenanceState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final token = await CacheManager.getToken();
      final categoriesList = await repository.getCategories(token!);
      emit(state.copyWith(isLoading: false, categories: categoriesList));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _selectCategory(SelectCategory event, Emitter<MaintenanceState> emit) {
  emit(state.copyWith(selectedCategoryId: event.categoryId));
  }


  void _onNextStep(NextStepEvent event, Emitter<MaintenanceState> emit) {
    if (state.currentStep < 3) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void _onPreviousStep(
    PreviousStepEvent event,
    Emitter<MaintenanceState> emit,
  ) {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onSelectService(SelectService event, Emitter<MaintenanceState> emit) {
    emit(state.copyWith(selectedService: event.service));
  }

  void _onUpdateDescriptionText(
    UpdateDescriptionText event,
    Emitter<MaintenanceState> emit,
  ) {
    emit(state.copyWith(descriptionText: event.text));
  }

  void _onAddImage(AddImage event, Emitter<MaintenanceState> emit) {
    final newList = List<File>.from(state.selectedImages)..add(event.image);
    emit(state.copyWith(selectedImages: newList));
  }

  void _onRemoveImage(RemoveImage event, Emitter<MaintenanceState> emit) {
    final newList = List<File>.from(state.selectedImages)
      ..removeAt(event.index);
    emit(state.copyWith(selectedImages: newList));
  }
}

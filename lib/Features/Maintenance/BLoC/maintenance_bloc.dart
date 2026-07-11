import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Data/Repositories/maintenance_repository.dart';
import 'maintenance_event.dart';
import 'maintenance_state.dart';

class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  final MaintenanceRepository repository;

  MaintenanceBloc({required this.repository}) : super(MaintenanceState(isLoading: true)) {

    on<LoadMaintenanceData>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final token = await CacheManager.getToken();

        final tickets = await repository.getTickets(token!);
        final statuses = await repository.getTicketStatuses(token); // تأكد من وجود هذه الدالة في الـ Repo

        final past = tickets.where((t) => t.state.toLowerCase() == 'done' || t.state.toLowerCase() == 'cancelled').toList();
        final active = tickets.where((t) => t.state.toLowerCase() != 'done' && t.state.toLowerCase() != 'cancelled').toList();

        emit(state.copyWith(
            isLoading: false,
            activeRequests: active,
            pastRequests: past,
            statuses: statuses
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<SubmitTicket>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final token = await CacheManager.getToken();
        await repository.createTicket(
          token: token!,
          subject: event.subject,
          description: event.description,
          unitId: 1,
          categoryId: 1,
          priority: "2",
        );
        add(LoadMaintenanceData());
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<RateTicket>((event, emit) async {
      try {
        final token = await CacheManager.getToken();
        await repository.rateTicket(
          token: token!,
          ticketId: event.ticketId,
          rating: event.rating,
          feedback: event.feedback,
        );

        add(LoadMaintenanceData());
      } catch (e) {
        print("Error rating ticket: $e");
      }
    });

    on<SelectService>((event, emit) {
      emit(state.copyWith(selectedService: event.service));
    });

    on<AddImage>((event, emit) {
      final newList = List<File>.from(state.selectedImages)..add(event.image);
      emit(state.copyWith(selectedImages: newList));
    });

    on<RemoveImage>((event, emit) {
      final newList = List<File>.from(state.selectedImages)..removeAt(event.index);
      emit(state.copyWith(selectedImages: newList));
    });

    on<UpdateRating>((event, emit) {
      emit(state.copyWith(rating: event.rating));
    });
  }
}
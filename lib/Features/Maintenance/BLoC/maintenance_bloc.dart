import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'maintenance_event.dart';
import 'maintenance_state.dart';


class MaintenanceBloc extends Bloc<MaintenanceEvent, MaintenanceState> {
  MaintenanceBloc() : super(MaintenanceState(isLoading: true)) {

    on<LoadMaintenanceData>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1)); // محاكاة الاتصال
      emit(MaintenanceState(
        isLoading: false,
        activeRequests: [
          {
            "id": "REQ-8472",
            "title": "تكييف المجلس لا يعمل",
            "time": "منذ ساعتين",
            "statusIndex": 1, // تم التعيين
            "techName": "حسن علي"
          }
        ],
        pastRequests: [
          {"title": "تسريب في حمام الضيوف", "date": "12 أكتوبر 2023", "rating": 5}
        ],
      ));
    });

    on<SelectService>((event, emit) {
      emit(state.copyWith(selectedService: event.service));
    });

    on<UpdateDescription>((event, emit) {
      emit(state.copyWith(descriptionLength: event.length));
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
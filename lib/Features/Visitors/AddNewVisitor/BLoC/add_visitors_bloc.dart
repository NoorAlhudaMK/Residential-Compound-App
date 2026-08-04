import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/CacheManager/cache_manager.dart';
import '../../../../Data/Repositories/visitor_repository.dart';
import 'add_visitors_event.dart';
import 'add_visitors_state.dart';


class AddVisitorBloc extends Bloc<AddVisitorEvent, AddVisitorState> {
  final VisitorRepository repository;

  AddVisitorBloc({required this.repository}) : super(AddVisitorState()) {
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

    on<CreateVisitor>((event, emit) async {
      emit(
        state.copyWith(
          isGenerating: true,
          lastCreatedVisitor: null,
          errorMessage: null,
        ),
      );

      try {
        final user = await CacheManager.getUserModel();

        final residentId = (user.residentProfiles.isNotEmpty)
            ? user.residentProfiles.first.id
            : null;

        if (residentId == null) {
          emit(
            state.copyWith(
              isGenerating: false,
              errorMessage: "لم يتم العثور على ملف الساكن (residentId)",
            ),
          );
          return;
        }

        final token = await CacheManager.getToken();
        if (token == null) {
          emit(
            state.copyWith(
              isGenerating: false,
              errorMessage: "التوكن غير صالح، يرجى إعادة تسجيل الدخول",
            ),
          );
          return;
        }

        final newVisitor = await repository.addVisitor(
          token: token,
          name: event.name,
          phone: event.phone,
          unitId: user.units![0].id,
          validFrom: event.validFrom,
          validTo: event.validTo,
          hasCar: event.hasCar,
          carPlate: event.carPlate,
          residentId: residentId,
        );

        emit(
          state.copyWith(
            isGenerating: false,
            lastCreatedVisitor: newVisitor,
            currentStep: 1,
            errorMessage: null,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isGenerating: false, errorMessage: e.toString()));
        if (kDebugMode) {
          print("🚨 خطأ قاتل أثناء إنشاء الزائر: $e");
        }
      }
    });

    on<UpdateHasCar>(
          (event, emit) => emit(state.copyWith(hasCar: event.value)),
    );

    on<UpdateIsTimeSelected>((event, emit) {
      emit(state.copyWith(isTimeSelected: event.isSelected));
    });

    on<UpdateDate>((event, emit) {
      emit(state.copyWith(selectedDate: event.date, isTimeSelected: false));
    });
  }
}
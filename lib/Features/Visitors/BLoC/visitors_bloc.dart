import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Data/Repositories/visitor_repository.dart';
import 'visitors_event.dart';
import 'visitors_state.dart';

class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  final VisitorRepository repository;

  VisitorBloc({required this.repository}) : super(VisitorState()) {
    on<FetchVisitors>((event, emit) async {
      try {
        final token = await CacheManager.getToken();

        if (token == null) {
          emit(state.copyWith(visitHistory: [], isGenerating: false));
          return;
        }

        final visitors = await repository.getVisitors(token);

        emit(state.copyWith(visitHistory: visitors ?? [], isGenerating: false));

      } catch (e) {
        debugPrint("Error fetching visitors: $e");
        emit(state.copyWith(isGenerating: false));
      }
    });

    on<ToggleTab>((event, emit) {
      emit(state.copyWith(activeTab: event.index));
    });

    on<CreateVisitor>((event, emit) async {
      emit(state.copyWith(isGenerating: true));

      try {
        final user = await CacheManager.getUserModel();

        final residentId = (user.residentProfiles.isNotEmpty)
            ? user.residentProfiles.first.id
            : null;

        if (residentId == null) {
          emit(state.copyWith(isGenerating: false));
          return;
        }

        final token = await CacheManager.getToken();

        final newVisitor = await repository.addVisitor(
          token: token!,
          name: event.name,
          phone: event.phone,
          unitId: event.unitId,
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
            activeTab: 1,
          ),
        );

        add(FetchVisitors());
      } catch (e) {
        emit(state.copyWith(isGenerating: false));
        if (kDebugMode) {
          print("Error creating visitor: $e");
        }
      }
    });

    on<UpdateHasCar>(
      (event, emit) => emit(state.copyWith(hasCar: event.value)),
    );

    on<UpdateCompanions>(
      (event, emit) => emit(state.copyWith(companionsCount: event.count)),
    );

    on<UpdateDate>(
      (event, emit) => emit(state.copyWith(selectedDate: event.date)),
    );

    on<UpdateRelation>(
      (event, emit) => emit(state.copyWith(relation: event.relation)),
    );

    on<ResetForm>((event, emit) {
      emit(state.copyWith(
        hasCar: false,
        companionsCount: 0,
        selectedDate: DateTime.now(),
      ));
    });
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Core/CacheManager/cache_manager.dart';
import '../../../../Data/Models/visitor_model.dart';
import '../../../../Data/Repositories/visitor_repository.dart';
import 'visitors_event.dart';
import 'visitors_state.dart';

class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  final VisitorRepository repository;

  VisitorBloc({required this.repository}) : super(VisitorState()) {
    on<FetchVisitors>((event, emit) async {
      if (event.isPagination) {
        if (state.isMoreLoading || !state.hasMore) return;
        emit(state.copyWith(isMoreLoading: true, errorMessage: null));
      } else {
        emit(
          state.copyWith(
            isLoading: true,
            errorMessage: null,
            currentPage: 1,
            currentStatus: event.status ?? state.currentStatus,
            searchQuery: event.search ?? state.searchQuery,
          ),
        );
      }

      try {
        final token = await CacheManager.getToken();
        if (token == null) {
          emit(
            state.copyWith(
              isLoading: false,
              isMoreLoading: false,
              errorMessage: "التوكن غير موجود، يرجى تسجيل الدخول مجدداً",
            ),
          );
          return;
        }

        final pageToFetch = event.isPagination ? state.currentPage + 1 : event.page;

        final visitors = await repository.getVisitors(
          token,
          status: event.status ?? state.currentStatus,
          search: event.search ?? state.searchQuery,
          page: pageToFetch,
          perPage: event.perPage,
        );

        final hasMoreData = visitors.isNotEmpty;

        final List<VisitorModel> updatedList = event.isPagination
            ? [...state.visitHistory, ...visitors]
            : visitors;

        emit(
          state.copyWith(
            visitHistory: updatedList,
            filteredVisitors: updatedList,
            isLoading: false,
            isMoreLoading: false,
            currentPage: pageToFetch,
            hasMore: hasMoreData,
            errorMessage: null,
          ),
        );
      } catch (e) {
        debugPrint("Error fetching visitors: $e");
        emit(
          state.copyWith(
            isLoading: false,
            isMoreLoading: false,
            errorMessage: e.toString(),
          ),
        );
      }
    });

    on<SearchVisitors>((event, emit) {
      add(
        FetchVisitors(
          search: event.query,
          status: state.currentStatus,
          page: 1,
          isPagination: false,
        ),
      );
    });
  }
}
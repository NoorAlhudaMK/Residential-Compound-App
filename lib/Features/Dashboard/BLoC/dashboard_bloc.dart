import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Data/Repositories/home_repository.dart';

import '../../../Core/CacheManager/cache_manager.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final HomeRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardLoading()) {

    on<FetchDashboardData>((event, emit) async {
      emit(DashboardLoading());
      try {
        final user = await CacheManager.getUserModel();
        final token = await CacheManager.getToken();

        final homeData = await repository.getHomeData(token!);

        emit(DashboardLoaded(user: user, homeData: homeData));
      } catch (e) {
        emit(DashboardFailure(message: "حدث خطأ أثناء جلب البيانات: $e"));
      }
    });
  }
}
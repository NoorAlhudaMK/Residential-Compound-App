import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardLoading()) {
    on<FetchDashboardData>((event, emit) async {
      await Future.delayed(const Duration(seconds: 1)); // محاكاة طلب API
      emit(DashboardLoaded(
        dueAmount: 1250,
        dueDate: "15 أكتوبر 2023",
        activities: [
          {"title": "اجتماع السكان السنوي", "time": "08:00 م", "date": "22 أبريل"},
          {"title": "صيانة المصاعد الدورية", "time": "10:00 ص", "date": "25 أبريل"},
        ],
      ));
    });
  }
}
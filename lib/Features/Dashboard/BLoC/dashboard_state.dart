import '../../../Data/Models/dashboard_data_model.dart';
import '../../../Data/Models/user_model.dart';

abstract class DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final UserModel user;
  final DashboardDataModel homeData;
  DashboardLoaded({required this.user, required this.homeData});
}

class DashboardFailure extends DashboardState {
  final String message;

  DashboardFailure({required this.message});
}
abstract class DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final double dueAmount;
  final String dueDate;
  final List<Map<String, dynamic>> activities;
  DashboardLoaded({required this.dueAmount, required this.dueDate, required this.activities});
}
import '../../../Data/Models/vehicle_model.dart';

abstract class VehiclesState {}

class VehiclesInitial extends VehiclesState {}

class VehiclesLoaded extends VehiclesState {
  final List<VehicleModel> vehicles;
  VehiclesLoaded(this.vehicles);
}
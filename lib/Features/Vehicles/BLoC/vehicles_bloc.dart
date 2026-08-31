import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Models/vehicle_model.dart';
import 'vehicles_event.dart';
import 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  VehiclesBloc() : super(VehiclesLoaded([
    VehicleModel(
      name: 'Toyota Land Cruiser',
      details: 'ERB 21 48291 • Parking P2-084',
    ),
    VehicleModel(
      name: 'Kia Sportage',
      details: 'ERB 33 12902 • Visitor slot eligible',
    ),
  ])) {
    on<LoadVehicles>((event, emit) {
      // هنا يمكنك جلب البيانات من الـ API أو قاعدة البيانات المحليات
    });
  }
}
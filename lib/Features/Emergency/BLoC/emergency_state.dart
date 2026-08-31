import '../../../Data/Models/emergency_option_model.dart';

abstract class EmergencyState {}

class EmergencyLoaded extends EmergencyState {
  final List<EmergencyOptionModel> options;
  final int? selectedIndex;

  EmergencyLoaded({required this.options, this.selectedIndex});

  EmergencyLoaded copyWith({List<EmergencyOptionModel>? options, int? selectedIndex}) {
    return EmergencyLoaded(
      options: options ?? this.options,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
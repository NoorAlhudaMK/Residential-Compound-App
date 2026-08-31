abstract class EmergencyEvent {}

class LoadEmergencyOptions extends EmergencyEvent {}

class SelectEmergencyType extends EmergencyEvent {
  final int index;
  SelectEmergencyType(this.index);
}

class TriggerEmergencyAlert extends EmergencyEvent {}
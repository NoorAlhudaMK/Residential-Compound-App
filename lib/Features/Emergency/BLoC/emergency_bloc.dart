import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Models/emergency_option_model.dart';
import 'emergency_event.dart';
import 'emergency_state.dart';

class EmergencyBloc extends Bloc<EmergencyEvent, EmergencyState> {
  EmergencyBloc() : super(EmergencyLoaded(
    options: [
      EmergencyOptionModel(title: 'خطر كهربائي أو مائي', icon: Icons.bolt_outlined),
      EmergencyOptionModel(title: 'مشكلة أمنية', icon: Icons.security_outlined),
      EmergencyOptionModel(title: 'مساعدة طبية', icon: Icons.help_outline),
    ],
    selectedIndex: 0,
  )) {
    on<SelectEmergencyType>((event, emit) {
      if (state is EmergencyLoaded) {
        final currentState = state as EmergencyLoaded;
        emit(currentState.copyWith(selectedIndex: event.index));
      }
    });

    on<TriggerEmergencyAlert>((event, emit) {
      // منطق إرسال تنبيه الطوارئ لفريق المجمع
    });
  }
}
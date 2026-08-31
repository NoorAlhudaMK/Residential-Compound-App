import 'package:flutter_bloc/flutter_bloc.dart';

import 'setting_event.dart';
import 'setting_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState()) {}
}

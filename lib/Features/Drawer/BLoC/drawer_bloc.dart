import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawer_event.dart';
import 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc(super.initialState);
}

class DrawerBlocManager extends Bloc<DrawerEvent, DrawerState> {
  DrawerBlocManager() : super(DrawerState(currentAlias: 'home')) {
    on<ChangeDrawerPageEvent>((event, emit) {
      emit(DrawerState(currentAlias: event.alias));
    });
  }
}
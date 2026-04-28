import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(currentIndex: 0)) {
    on<ChangeTabEvent>((event, emit) {
      emit(HomeState(currentIndex: event.index));
    });
  }
}
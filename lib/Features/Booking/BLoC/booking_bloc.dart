import 'package:flutter_bloc/flutter_bloc.dart';

import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingState(selectedDate: DateTime.now())) {
    on<SelectFacility>((event, emit) => emit(BookingState(
      selectedFacilityIndex: event.index,
      selectedDate: state.selectedDate,
    )));
    on<SelectDate>((event, emit) => emit(BookingState(
      selectedFacilityIndex: state.selectedFacilityIndex,
      selectedDate: event.date,
    )));
  }
}
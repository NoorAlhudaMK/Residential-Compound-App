abstract class BookingEvent {}
class SelectFacility extends BookingEvent { final int index; SelectFacility(this.index); }
class SelectDate extends BookingEvent { final DateTime date; SelectDate(this.date); }
abstract class SupportEvent {}

class CallCommunityOfficeEvent extends SupportEvent {
  final String phoneNumber;
  CallCommunityOfficeEvent(this.phoneNumber);
}
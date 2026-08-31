abstract class ForgotPasswordEvent {}

class SubmitForgotPasswordEvent extends ForgotPasswordEvent {
  final String email;
  SubmitForgotPasswordEvent({required this.email});
}
abstract class SupportState {}

class SupportInitial extends SupportState {}

class SupportCallLoading extends SupportState {}

class SupportCallSuccess extends SupportState {}

class SupportCallError extends SupportState {
  final String message;
  SupportCallError(this.message);
}
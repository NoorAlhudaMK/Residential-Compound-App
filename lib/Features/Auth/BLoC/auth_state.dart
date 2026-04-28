abstract class AuthState {}

class AuthInitial extends AuthState {
  final bool isPasswordVisible;

  AuthInitial({this.isPasswordVisible = true});
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String guardName;
  AuthSuccess(this.guardName);
}

class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}

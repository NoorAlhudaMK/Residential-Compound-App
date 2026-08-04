abstract class AuthState {
  final bool isPasswordVisible;
  AuthState({this.isPasswordVisible = false});
}

class AuthInitial extends AuthState {
  AuthInitial({super.isPasswordVisible});
}

class AuthLoading extends AuthState {
  AuthLoading({super.isPasswordVisible});
}

class AuthSuccess extends AuthState {
  final String userName;
  AuthSuccess(this.userName, {super.isPasswordVisible});
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error, {super.isPasswordVisible});
}
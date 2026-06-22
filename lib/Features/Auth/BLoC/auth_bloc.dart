import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {

    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());

      try {
        await Future.delayed(Duration(seconds: 2));

        if (event.username == "7777777777" && event.password == "1234") {
          emit(AuthSuccess("أشرف شروفي"));
        } else {
          emit(AuthFailure("اسم المستخدم أو كلمة المرور غير صحيحة"));
        }
      } catch (e) {
        emit(AuthFailure("حدث خطأ في الاتصال بالسيرفر"));
      }
    });

    on<LogoutRequested>((event, emit) {
      emit(AuthInitial());
    });

    on<TogglePasswordVisibility>((event, emit) {
      if (state is AuthInitial) {
        final currentState = state as AuthInitial;
        emit(AuthInitial(isPasswordVisible: !currentState.isPasswordVisible));
      }
    });
  }
}
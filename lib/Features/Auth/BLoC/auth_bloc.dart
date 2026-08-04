import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Data/Repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {

    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final loginResponse = await authRepository.login(event.username, event.password);

        final token = loginResponse.token!;

        bool hasAccess = await authRepository.checkUserAccess(token);
        if (!hasAccess) {
          emit(AuthFailure("عفواً، ليس لديك صلاحية الدخول كـ resident"));
          return;
        }

        final user = await authRepository.fetchAndCacheUserProfile(token);
        await CacheManager.saveUserData(user);

        emit(AuthSuccess(user.name));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        String? token = await CacheManager.getToken();

        if (token != null) {
          await authRepository.logout(token);
        }

        await CacheManager.clearAll();

        emit(AuthInitial());
      } catch (e) {
        await CacheManager.clearAll();
        emit(AuthInitial());
      }
    });

    on<TogglePasswordVisibility>((event, emit) {
      final currentState = state;
      final bool newVisibility = !currentState.isPasswordVisible;

      if (currentState is AuthInitial) {
        emit(AuthInitial(isPasswordVisible: newVisibility));
      } else if (currentState is AuthFailure) {
        emit(AuthFailure(currentState.error, isPasswordVisible: newVisibility));
      } else if (currentState is AuthLoading) {
        emit(AuthLoading(isPasswordVisible: newVisibility));
      } else if (currentState is AuthSuccess) {
        emit(AuthSuccess(currentState.userName,isPasswordVisible: newVisibility));
      }
    });
  }
}
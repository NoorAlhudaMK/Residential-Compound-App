import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Data/Repositories/auth_repository.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';


class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordBloc({required this.authRepository}) : super(ForgotPasswordInitial()) {
    on<SubmitForgotPasswordEvent>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        final message = await authRepository.forgotPassword(event.email);
        emit(ForgotPasswordSuccess(message: message));
      } catch (e) {
        emit(ForgotPasswordFailure(error: e.toString().replaceAll("Exception: ", "")));
      }
    });
  }
}
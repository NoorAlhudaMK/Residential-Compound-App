import 'package:flutter_bloc/flutter_bloc.dart';
import 'support_event.dart';
import 'support_state.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportBloc extends Bloc<SupportEvent, SupportState> {
  SupportBloc() : super(SupportInitial()) {
    on<CallCommunityOfficeEvent>(_onCallCommunityOffice);
  }

  Future<void> _onCallCommunityOffice(
      CallCommunityOfficeEvent event,
      Emitter<SupportState> emit,
      ) async {
    emit(SupportCallLoading());
    try {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: event.phoneNumber,
      );

      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
        emit(SupportCallSuccess());
      } else {
        emit(SupportCallError("تعذر إجراء الاتصال بهذا الرقم"));
      }
    } catch (e) {
      emit(SupportCallError(e.toString()));
    }
  }
}
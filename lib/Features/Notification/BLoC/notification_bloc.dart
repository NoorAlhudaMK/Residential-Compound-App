import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Data/Repositories/notification_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;
  NotificationBloc(this.repository) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      final token = await CacheManager.getToken();
      emit(NotificationLoading());
      try {
        final notifications = await repository.fetchNotifications(token!);
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }
}

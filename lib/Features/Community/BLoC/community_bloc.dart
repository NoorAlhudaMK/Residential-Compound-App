import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Data/Repositories/community_repository.dart';
import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CommunityRepository repository;

  CommunityBloc({required this.repository}) : super(CommunityState()) {

    on<LoadAnnouncements>((event, emit) async {
      emit(state.copyWith(status: CommunityStatus.loading));

      try {
        final token = await CacheManager.getToken();
        final announcements = await repository.fetchAnnouncements(token!);

        emit(state.copyWith(
            status: CommunityStatus.success,
            announcements: announcements
        ));
      } catch (e) {
        emit(state.copyWith(status: CommunityStatus.failure, errorMessage: e.toString()));
      }
    });

    on<ToggleLike>((event, emit) {
      emit(state.copyWith(announcements: List.from(state.announcements)));
    });
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/Colors/app_colors.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileState()) {

    on<LoadThemeEvent>((event, emit) async {
      bool isDark = await CacheManager.getThemeMode();
      AppColors.isDark = isDark;
      emit(state.copyWith(isDark: isDark));
    });

    on<ToggleThemeEvent>((event, emit) async {
      AppColors.isDark = event.isDark;

      await CacheManager.saveThemeMode(isDark: event.isDark);

      emit(state.copyWith(isDark: event.isDark));
    });

    on<ChangeLanguageEvent>((event, emit) {
      emit(state.copyWith(languageCode: event.languageCode));
    });
  }
}
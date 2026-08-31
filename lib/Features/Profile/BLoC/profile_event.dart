abstract class ProfileEvent {}

class ToggleThemeEvent extends ProfileEvent {
  final bool isDark;
  ToggleThemeEvent(this.isDark);
}

class ChangeLanguageEvent extends ProfileEvent {
  final String languageCode;
  ChangeLanguageEvent(this.languageCode);
}

class LoadThemeEvent extends ProfileEvent {}
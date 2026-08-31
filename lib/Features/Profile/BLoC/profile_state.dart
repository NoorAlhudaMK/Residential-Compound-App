class ProfileState {
  final bool isDark;
  final String languageCode;

  ProfileState({this.isDark = false, this.languageCode = 'ar'});

  ProfileState copyWith({bool? isDark, String? languageCode}) {
    return ProfileState(
      isDark: isDark ?? this.isDark,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}
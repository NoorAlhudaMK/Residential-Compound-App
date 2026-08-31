import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Core/CacheManager/cache_manager.dart';
import 'package:residential_compound_app/Core/UIConstants/aivio_spacing.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/user_model.dart';
import '../../Auth/BLoC/auth_bloc.dart';
import '../../Auth/BLoC/auth_event.dart';
import '../../Auth/BLoC/auth_state.dart';
import '../../Auth/View/login_view.dart';
import '../../MainPage/BLoC/home_bloc.dart';
import '../../MainPage/BLoC/home_event.dart';
import '../BLoC/profile_bloc.dart';
import '../BLoC/profile_event.dart';
import '../BLoC/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, settingsState) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: colors.scaffoldBackground,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                automaticallyImplyActions: false,
                centerTitle: true,
                title: Text(
                  'الملف والإعدادات',
                  style: TextStyle(
                    color: colors.textMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.inputFill,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colors.inputBorder),
                    ),
                    child: Icon(
                      Icons.arrow_back_outlined,
                      color: colors.textMain,
                      size: 20,
                    ),
                  ),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
              body: FutureBuilder<UserModel>(
                future: getUser(),
                builder: (context, snapshot) {

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (snapshot.hasData)
                          _buildProfileInfoHeader(snapshot.data!, colors),
                        SizedBox(height: AppSpacing.xxl),

                        Text(
                          'اللغة',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildLangCard(
                                context,
                                colors,
                                'EN',
                                'English',
                                'en',
                                settingsState.languageCode,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildLangCard(
                                context,
                                colors,
                                'ع',
                                'العربية',
                                'ar',
                                settingsState.languageCode,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildLangCard(
                                context,
                                colors,
                                'ك',
                                'كوردى',
                                'ku',
                                settingsState.languageCode,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Text(
                          'المظهر',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildThemeCard(
                                context,
                                colors,
                                Icons.wb_sunny_outlined,
                                'فاتح',
                                false,
                                !settingsState.isDark,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildThemeCard(
                                context,
                                colors,
                                Icons.nightlight_round,
                                'داكن',
                                true,
                                settingsState.isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                         Container(
                            decoration: BoxDecoration(
                              color: colors.inputFill,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: colors.inputBorder),
                            ),
                            child: Column(
                              children: [
                                _buildProfileItem(
                                  context,
                                  Icons.logout,
                                  "تسجيل الخروج",
                                  colors,
                                  isLogout: true,
                                  onTap: () => _handleLogout(context),
                                ),
                              ],
                            ),
                          ),

                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileInfoHeader(UserModel user, AppColors colors) {
    final username = user.name ?? '';
    final email = user.residentProfiles[0].email ?? '';
    final phone = user.residentProfiles[0].phone ?? '';

    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              username.isNotEmpty ? username.substring(0, min(2, username.length)).toUpperCase() : 'AH',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(
                color: colors.textMain,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              phone,
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String trailingText,
    required AppColors colors,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colors.primary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: colors.primary, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colors.textMain,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailingText,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: colors.textSecondary,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildLangCard(
      BuildContext context,
      AppColors colors,
      String title,
      String subtitle,
      String code,
      String currentLang,
      ) {
    final isSelected = currentLang == code;
    return GestureDetector(
      onTap: () => context.read<ProfileBloc>().add(ChangeLanguageEvent(code)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colors.inputFill : colors.secondaryBtnBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.inputBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? colors.primary : colors.textMain,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: colors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(
      BuildContext context,
      AppColors colors,
      IconData icon,
      String title,
      bool isDarkTheme,
      bool isSelected,
      ) {
    return GestureDetector(
      onTap: () => context.read<ProfileBloc>().add(ToggleThemeEvent(isDarkTheme)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? colors.inputFill : colors.secondaryBtnBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.primary : colors.inputBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? colors.primary : colors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? colors.primary : colors.textMain,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
      BuildContext context,
      IconData icon,
      String title,
      AppColors colors, {
        bool isLogout = false,
        VoidCallback? onTap,
      }) {
    Color itemColor = isLogout ? Colors.red : colors.textMain;
    return ListTile(
      title: Text(title, style: TextStyle(color: itemColor, fontWeight: FontWeight.w500)),
      trailing: isLogout
          ? const Icon(Icons.logout, color: Colors.red, size: 20)
          : const Icon(Icons.arrow_back_ios, size: 16),
      onTap: onTap,
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'تأكيد تسجيل الخروج',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);

                context.read<HomeBloc>().add(ChangeTabEvent(0));

                context.read<AuthBloc>().add(LogoutRequested());

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                      (route) => false,
                );
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<UserModel> getUser() async {
    return await CacheManager.getUserModel();
  }

  int min(int a, int b) => a < b ? a : b;
}
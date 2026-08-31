import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Core/CacheManager/cache_manager.dart';
import 'package:residential_compound_app/Features/Profile/BLoC/profile_state.dart';
import 'package:residential_compound_app/Features/Profile/View/profile_view.dart';
import 'package:residential_compound_app/Features/Support/View/support_view.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../../Data/Models/user_model.dart';
import '../../Dashboard/View/unit_details_page.dart';
import '../../Documents/View/documents_view.dart';
import '../../Emergency/View/emergency_view.dart';
import '../../FamilyMembers/View/family_members_view.dart';
import '../../MainPage/BLoC/home_bloc.dart';
import '../../MainPage/BLoC/home_event.dart';
import '../../NoticeDetail/View/notice_detail_view.dart';
import '../../Notification/BLoC/notification_bloc.dart';
import '../../Notification/BLoC/notification_state.dart';
import '../../Notification/View/notification_view.dart';
import '../../Profile/BLoC/profile_bloc.dart';
import '../../Profile/BLoC/profile_event.dart';
import '../../Vehicles/View/vehicles_view.dart';
import '../BLoC/setting_bloc.dart';
import '../BLoC/setting_state.dart';

class ProfileAndSettingsScreen extends StatelessWidget {
  const ProfileAndSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        final colors = AppColors();

        return BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: colors.scaffoldBackground,
                  appBar: AppBar(
                    backgroundColor: colors.scaffoldBackground,
                    elevation: 0.0,
                    scrolledUnderElevation: 0.0,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    automaticallyImplyActions: false,
                    leading: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.sm, right: AppSpacing.sm),
                      child: Image.asset(
                        profileState.isDark
                            ? "assets/images/aivio_logo_white.png"
                            : "assets/images/aivio_logo_black.png",
                        scale: 4,
                      ),
                    ),
                    leadingWidth: MediaQuery.of(context).size.width * .25,
                    actions: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppSpacing.sm,
                          top: AppSpacing.sm,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            context.read<ProfileBloc>().add(
                              ToggleThemeEvent(!profileState.isDark),
                            );
                            context.read<HomeBloc>().add(ChangeTabEvent(4));
                          },
                          child: _buildCustomButton(
                            profileState.isDark
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            false,
                            colors,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Padding(
                        padding: EdgeInsets.only(left: AppSpacing.sm, top: AppSpacing.sm),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationView()),
                          ),
                          child: BlocBuilder<NotificationBloc, NotificationState>(
                            builder: (context, notificationState) {
                              bool hasUnread = false;

                              if (notificationState is NotificationLoaded) {
                                hasUnread = notificationState.notifications.any(
                                      (notification) => notification.readDate == null,
                                );
                              }

                              return _buildCustomButton(
                                Icons.notifications_none_rounded,
                                hasUnread,
                                colors,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: FutureBuilder<UserModel>(
                    future: getUser(),
                    builder: (context, snapshot) {
                      final unitName =
                      snapshot.hasData &&
                          (snapshot.data?.residentProfiles.isNotEmpty ?? false)
                          ? snapshot.data!.residentProfiles[0].primaryUnit.code
                          : '';

                      return SingleChildScrollView(
                        padding: AppSpacing.allMd,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (snapshot.hasData)
                              _buildProfileInfoHeader(snapshot.data!, colors),
                            const SizedBox(height: AppSpacing.lg),
                            Container(
                              decoration: BoxDecoration(
                                color: colors.inputFill,
                                borderRadius: AppRadius.lgRadius,
                                border: Border.all(color: colors.inputBorder),
                              ),
                              child: Column(
                                children: [
                                  _buildSettingsItem(
                                    icon: Icons.apartment_rounded,
                                    title: 'وحدتي',
                                    trailingText: unitName,
                                    colors: colors,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UnitDetailsPage(
                                            unit: snapshot
                                                .data!
                                                .residentProfiles[0]
                                                .primaryUnit,
                                            owner: snapshot.data!.name,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(height: 1, color: colors.inputBorder),
                                  _buildSettingsItem(
                                    icon: Icons.group_outlined,
                                    title: 'أفراد العائلة',
                                    trailingText: '3 أفراد',
                                    colors: colors,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const FamilyMembersScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(height: 1, color: colors.inputBorder),
                                  _buildSettingsItem(
                                    icon: Icons.directions_car_filled_outlined,
                                    title: 'المركبات',
                                    trailingText: '4 مركبات',
                                    colors: colors,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const VehiclesScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Container(
                              decoration: BoxDecoration(
                                color: colors.inputFill,
                                borderRadius: AppRadius.lgRadius,
                                border: Border.all(color: colors.inputBorder),
                              ),
                              child: Column(
                                children: [
                                  _buildSettingsItem(
                                    icon: Icons.description_outlined,
                                    title: 'العقود والمستندات',
                                    trailingText: '',
                                    colors: colors,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const DocumentsScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(height: 1, color: colors.inputBorder),
                                  _buildSettingsItem(
                                    icon: Icons.notifications_none_outlined,
                                    title: 'الإشعارات',
                                    trailingText: '',
                                    colors: colors,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const NotificationView(),
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(height: 1, color: colors.inputBorder),
                                  _buildSettingsItem(
                                    icon: Icons.apartment_outlined,
                                    title: 'إشعار المجتمع',
                                    trailingText: '',
                                    colors: colors,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const NoticeDetailScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Container(
                              decoration: BoxDecoration(
                                color: colors.inputFill,
                                borderRadius: AppRadius.lgRadius,
                                border: Border.all(color: colors.inputBorder),
                              ),
                              child: Column(
                                children: [
                                  _buildSettingsItem(
                                    icon: Icons.report_problem_outlined,
                                    title: 'طوارئ',
                                    trailingText: '24/7',
                                    colors: colors,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const EmergencyScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(height: 1, color: colors.inputBorder),
                                  _buildSettingsItem(
                                    icon: Icons.help_outline_outlined,
                                    title: 'الدعم',
                                    trailingText: '',
                                    colors: colors,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const SupportCenterScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(height: 1, color: colors.inputBorder),
                                  _buildSettingsItem(
                                    icon: Icons.tune_outlined,
                                    title: 'الملف والإعدادات',
                                    trailingText: '',
                                    colors: colors,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) => ProfileBloc(),
                                            child: const ProfileScreen(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
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
      },
    );
  }

  Widget _buildProfileInfoHeader(UserModel user, AppColors colors) {
    final username = user.name ?? '';
    final unitName = (user.residentProfiles.isNotEmpty)
        ? user.residentProfiles[0].primaryUnit.name ?? ''
        : '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: AppRadius.xlRadius,
          ),
          child: Center(
            child: Text(
              username.isNotEmpty
                  ? username.substring(0, min(2, username.length)).toUpperCase()
                  : 'AH',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.headingMedium,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'مساء الخير',
              style: TextStyle(
                color: Colors.grey,
                fontSize: AppFontSizes.bodySmall,
              ),
            ),
            Text(
              username,
              style: TextStyle(
                color: colors.textMain,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.headingSmall,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Text(
                  'الشقة',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: AppFontSizes.bodySmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  unitName,
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: AppFontSizes.bodyMedium,
                  ),
                ),
              ],
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
        padding: AppSpacing.allSm,
        decoration: BoxDecoration(
          color: colors.primary.withOpacity(0.15),
          borderRadius: AppRadius.mdRadius,
        ),
        child: Icon(icon, color: colors.primary, size: AppIconSizes.md),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colors.textMain,
          fontWeight: FontWeight.bold,
          fontSize: AppFontSizes.bodyMedium,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trailingText,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: AppFontSizes.bodyMedium,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(
            Icons.arrow_forward_ios,
            size: AppIconSizes.xs,
            color: colors.textSecondary,
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildCustomButton(IconData icon, bool hasNotification, AppColors colors) {
    return Container(
      width: AppIconSizes.xl,
      height: AppIconSizes.xl,
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: colors.textMain, size: AppIconSizes.md),
          if (hasNotification)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.danger,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<UserModel> getUser() async {
    return await CacheManager.getUserModel();
  }

  int min(int a, int b) => a < b ? a : b;
}
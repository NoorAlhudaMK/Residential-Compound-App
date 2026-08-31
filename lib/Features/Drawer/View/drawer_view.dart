import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Core/UIConstants/aivio_icon_sizes.dart';

import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Data/Models/user_model.dart';
import '../../AboutApp/View/about_app.dart';
import '../../Auth/BLoC/auth_bloc.dart';
import '../../Auth/BLoC/auth_event.dart';
import '../../Auth/View/login_view.dart';
import '../../MainPage/BLoC/home_bloc.dart';
import '../../MainPage/BLoC/home_event.dart';
import '../../Maintenance/AddMaintenanceTicket/View/add_new_maintenance_view.dart';
import '../../Notification/View/notification_view.dart';
import '../../Visitors/AddNewVisitor/View/add_new_visitor.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  AppColors colors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(child: residentialDrawer(context)),
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

  Widget residentialDrawer(BuildContext context) {
    return FutureBuilder<UserModel?>(
      future: CacheManager.getUserModel(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        UserModel? user = snapshot.data;
        String userName = user?.name ?? 'مستخدم';
        String userEmail = user?.residentProfiles[0].email ?? 'email';

        return Drawer(
          child: Container(
            color: AppColors().scaffoldBackground,
            child: SafeArea(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: colors.primary),
                    accountName: Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(
                      userEmail,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        color: AppColors().textMain,
                      ),
                    ),
                    currentAccountPicture: const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.blueGrey,
                      ),
                    ),
                    onDetailsPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ProfileAndSettingsScreen(
                      //
                      //     ),
                      //   ),
                      // );
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.home_outlined,
                              size: AppIconSizes.md,
                              color: AppColors().textMain,
                            ),
                            title: Text(
                              'الرئيسية',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                color: AppColors().textMain,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              context.read<HomeBloc>().add(ChangeTabEvent(0));
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.security_outlined,
                              size: AppIconSizes.md,
                              color: AppColors().textMain,
                            ),
                            title: Text(
                              'الزوار',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                color: AppColors().textMain,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              context.read<HomeBloc>().add(ChangeTabEvent(1));
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.build_outlined,
                              size: AppIconSizes.md,
                              color: AppColors().textMain,
                            ),
                            title: Text(
                              'الصيانة',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                color: AppColors().textMain,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              context.read<HomeBloc>().add(ChangeTabEvent(2));
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.receipt_long_outlined,
                              size: AppIconSizes.md,
                              color: AppColors().textMain,
                            ),
                            title: Text(
                              'الفواتير',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                color: AppColors().textMain,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              context.read<HomeBloc>().add(ChangeTabEvent(2));
                            },
                          ),
                          const Divider(height: 10),
                          ListTile(
                            leading: Icon(
                              Icons.qr_code,
                              size: AppIconSizes.md,
                              color: AppColors().textMain,
                            ),
                            title: Text(
                              'إضافة تصريح دخول',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                color: AppColors().textMain,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddNewVisitorView(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.build_outlined,
                              size: AppIconSizes.md,
                              color: AppColors().textMain,
                            ),
                            title: Text(
                              'إضافة طلب صيانة',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                color: AppColors().textMain,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewMaintenanceRequestView(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 10),
                          ListTile(
                            leading: Icon(
                              Icons.notifications_outlined,
                              size: AppIconSizes.md,
                              color: AppColors().textMain,
                            ),
                            title: Text(
                              'الإشعارات',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                color: AppColors().textMain,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationView(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.info_outline,
                              size: AppIconSizes.md,
                              color: AppColors().textMain,
                            ),
                            title: Text(
                              'حول التطبيق',
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyMedium,
                                color: AppColors().textMain,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AboutAppPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 10),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      size: AppIconSizes.md,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'تسجيل الخروج',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () => _handleLogout(context),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

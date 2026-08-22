import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../../Data/Repositories/notification_repository.dart';
import '../BLoC/notification_bloc.dart';
import '../BLoC/notification_event.dart';
import '../BLoC/notification_state.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return BlocProvider(
      create: (context) => NotificationBloc(NotificationRepository())..add(LoadNotifications()),
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: colors.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: colors.scaffoldBackground,
              elevation: 0,
              scrolledUnderElevation: 0.0,
              title: Text(
                "الإشــعــارات",
                style: TextStyle(
                  color: colors.textMain,
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.headingSmall,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new, size: AppIconSizes.md,
                  color: colors.textMain, ),
              ),
            ),
            body: BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  );
                }
                if (state is NotificationLoaded) {
                  if (state.notifications.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد إشعارات حالياً",
                        style: TextStyle(
                          fontSize: AppFontSizes.bodyMedium,
                          color: colors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: AppSpacing.allMd,
                    itemCount: state.notifications.length,
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final item = state.notifications[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.mdRadius,
                          border: Border.all(color: const Color(0xFFF1F5F9)),
                        ),
                        padding: AppSpacing.allMd,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_outlined,
                                color: colors.primary,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: AppFontSizes.bodyLarge,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textMain,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        item.createDate,
                                        style: TextStyle(
                                          fontSize: AppFontSizes.caption,
                                          color: colors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.body,
                                    style: TextStyle(
                                      color: colors.textSecondary,
                                      fontSize: AppFontSizes.bodySmall,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                if (state is NotificationError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
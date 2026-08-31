import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
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
      create: (context) =>
          NotificationBloc(NotificationRepository())..add(LoadNotifications()),
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
                  color: colors.textAppBar,
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.headingSmall,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Container(
                  padding: AppSpacing.allSm,
                  decoration: BoxDecoration(
                    color: colors.inputFill,
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(color: colors.inputBorder),
                  ),
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: colors.textMain,
                    size: AppIconSizes.md,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              automaticallyImplyActions: false,
              automaticallyImplyLeading: false,
              actions: [
                BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    if (state is NotificationLoaded &&
                        state.notifications.isNotEmpty) {
                      return TextButton(
                        onPressed: () {
                          List<int> allIds = state.notifications
                              .map((e) => e.id)
                              .toList();
                          context.read<NotificationBloc>().add(
                            MarkNotificationsAsReadEvent(allIds),
                          );
                        },
                        child: Text(
                          "تعليم الكل كمقروء",
                          style: TextStyle(
                            color: colors.textAppBar,
                            fontSize: AppFontSizes.bodySmall,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
            body: BlocConsumer<NotificationBloc, NotificationState>(
              listener: (context, state) {},
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
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = state.notifications[index];
                      final bool isUnread = item.readDate == null;

                      return InkWell(
                        onTap: () {
                          if (isUnread) {
                            context.read<NotificationBloc>().add(
                              MarkSingleNotificationAsRead(item.id),
                            );
                          }
                        },
                        borderRadius: AppRadius.mdRadius,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isUnread
                                ? colors.primary.withOpacity(0.03)
                                : colors.inputFill,
                            borderRadius: AppRadius.mdRadius,
                            border: Border.all(
                              color: isUnread
                                  ? colors.primary.withOpacity(0.25)
                                  : colors.inputBorder,
                              width: isUnread ? 1.5 : 1.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colors.textAppBar.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.notifications_rounded,
                                      color: colors.textAppBar,
                                      size: 24,
                                    ),
                                  ),
                                  if (isUnread)
                                    Positioned(
                                      top: -2,
                                      right: -2,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: colors.danger,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: TextStyle(
                                              fontSize: AppFontSizes.bodyLarge,
                                              fontWeight: isUnread
                                                  ? FontWeight.w800
                                                  : FontWeight.w600,
                                              color: colors.textMain,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // تنسيق تاريخ إنشاء الإشعار في الأعلى
                                        // Text(
                                        //   _formatDateTime(item.createDate),
                                        //   style: TextStyle(
                                        //     fontSize: AppFontSizes.caption - 2,
                                        //     color: colors.textSecondary,
                                        //   ),
                                        // ),
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
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        if (item.type.isNotEmpty)
                                          _buildChip(
                                            label: item.type,
                                            color: colors.primary,
                                            backgroundColor: colors.primary
                                                .withOpacity(0.08),
                                          ),
                                        if (item.state.isNotEmpty)
                                          _buildChip(
                                            label: item.state,
                                            color: Colors.orange.shade800,
                                            backgroundColor: Colors.orange
                                                .withOpacity(0.08),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                     Divider(
                                      height: 1,
                                      color: colors.inputBorder,
                                    ),
                                    const SizedBox(height: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.send_outlined,
                                              size: 11,
                                              color: colors.textSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                // تنسيق وقت وتاريخ الإرسال
                                                "الإرسال: ${_formatDateTime(item.sentDate)}",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: colors.textSecondary,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              isUnread
                                                  ? Icons.access_time
                                                  : Icons.done_all,
                                              size: 11,
                                              color: isUnread
                                                  ? Colors.orange
                                                  : Colors.green,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                isUnread
                                                    ? "الحالة: غير مقروء"
                                                    : "القراءة: ${_formatDateTime(item.readDate)}",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: isUnread
                                                      ? Colors.orange
                                                      : Colors.green,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                        color: colors.danger,
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

  Widget _buildChip({
    required String label,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'غير متوفر';
    try {
      DateTime parsedDate = DateTime.parse(dateStr);
      return intl.DateFormat('dd/MM/yyyy  hh:mm:ss a')
          .format(parsedDate)
          .replaceFirst("AM", "صباحاُ")
          .replaceFirst("PM", "مساءً");
    } catch (e) {
      return dateStr;
    }
  }
}

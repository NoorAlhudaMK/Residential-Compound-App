import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../../Core/UIConstants/aivio_spacing.dart';
import '../../../../Data/Models/maintenance_ticket_model.dart';
import '../../../MainPage/BLoC/home_bloc.dart';
import '../../../MainPage/BLoC/home_event.dart';
import '../../../Notification/BLoC/notification_bloc.dart';
import '../../../Notification/BLoC/notification_state.dart';
import '../../../Notification/View/notification_view.dart';
import '../../../Profile/BLoC/profile_bloc.dart';
import '../../../Profile/BLoC/profile_event.dart';
import '../../../Profile/BLoC/profile_state.dart';
import '../../AddMaintenanceTicket/View/add_new_maintenance_view.dart';
import '../BLoC/maintenance_bloc.dart';
import '../BLoC/maintenance_event.dart';
import '../BLoC/maintenance_state.dart';

class MaintenanceView extends StatefulWidget {
  const MaintenanceView({super.key});

  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<MaintenanceBloc>().add(LoadMaintenanceData(status: ''));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      final bloc = context.read<MaintenanceBloc>();
      if (bloc.state.hasMore &&
          !bloc.state.isMoreLoading &&
          !bloc.state.isLoading) {
        bloc.add(LoadMaintenanceData(isPagination: true));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          final colors = AppColors();
          return Scaffold(
            backgroundColor: colors.scaffoldBackground,
            appBar: _buildHeader(colors, context),
            body: Padding(
              padding: AppSpacing.allSm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.lg),
                  Container(
                    width: AppFontSizes.headingLarge,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(
                        AppFontSizes.bodySmall,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'AIVIO CARE',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        "الــخــدمــات",
                        style: TextStyle(
                          color: colors.textMain,
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontSizes.headingMedium,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NewMaintenanceRequestView(),
                            ),
                          );
                        },
                        child: Container(
                          padding: AppSpacing.allSm,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: AppRadius.mdRadius,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_rounded,
                                size: AppIconSizes.md,
                                color: Colors.white,
                              ),
                              Text(
                                "طلب جديد",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppFontSizes.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: AppSpacing.md),
                    child: BlocBuilder<MaintenanceBloc, MaintenanceState>(
                      builder: (context, state) {
                        return TextField(
                          controller: _searchController,
                          onChanged: (query) {
                            context.read<MaintenanceBloc>().add(
                              SearchMaintenance(query),
                            );
                          },
                          decoration: InputDecoration(
                            hintText: "ابحث برقم الطلب، العنوان، أو الوصف...",
                            hintStyle: TextStyle(
                              color: colors.textSecondary,
                              fontSize: AppFontSizes.bodySmall,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: colors.textSecondary,
                              size: AppIconSizes.md,
                            ),
                            suffixIcon: state.searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: colors.textSecondary,
                                      size: AppIconSizes.sm,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      context.read<MaintenanceBloc>().add(
                                        SearchMaintenance(''),
                                      );
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: colors.inputFill,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colors.inputBorder),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colors.primary),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // SizedBox(
                  //   height: 50,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  //     itemCount: _statuses.length,
                  //     itemBuilder: (context, index) {
                  //       final statusItem = _statuses[index];
                  //       return BlocBuilder<MaintenanceBloc, MaintenanceState>(
                  //         builder: (context, state) {
                  //           final isSelected =
                  //               state.selectedStatusFilter == statusItem['key'];
                  //           return Padding(
                  //             padding: const EdgeInsets.only(left: 8.0),
                  //             child: ChoiceChip(
                  //               label: Text(statusItem['label']!),
                  //               selected: isSelected,
                  //               selectedColor: colors.primary,
                  //               backgroundColor: Colors.white,
                  //               labelStyle: TextStyle(
                  //                 color: isSelected
                  //                     ? Colors.white
                  //                     : colors.textSecondary,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //               onSelected: (selected) {
                  //                 if (selected) {
                  //                   context.read<MaintenanceBloc>().add(
                  //                     LoadMaintenanceData(
                  //                       status: statusItem['key'],
                  //                       page: 1,
                  //                     ),
                  //                   );
                  //                 }
                  //               },
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     },
                  //   ),
                  // ),
                  //SizedBox(height: AppSpacing.xs),
                  Expanded(
                    child: BlocConsumer<MaintenanceBloc, MaintenanceState>(
                      listener: (context, state) {
                        if (state.errorMessage != null &&
                            !state.isLoading &&
                            !state.isMoreLoading) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage!),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state.isLoading && state.tickets.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.tickets.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 64,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(height: AppSpacing.sm),
                                Text(
                                  "لا توجد طلبات صيانة مطابقة",
                                  style: TextStyle(
                                    color: colors.textSecondary,
                                    fontSize: AppFontSizes.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(top: AppSpacing.md),
                          itemCount:
                              state.tickets.length +
                              (state.isMoreLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.tickets.length) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: AppSpacing.md),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final req = state.tickets[index];
                            return _buildModernRequestCard(
                              context,
                              req,
                              colors,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildHeader(AppColors colors, BuildContext context) {
    return AppBar(
      backgroundColor: colors.scaffoldBackground,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      leading: Padding(
        padding: EdgeInsets.only(top: AppSpacing.sm, right: AppSpacing.sm),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, settingsState) {
            return Image.asset(
              settingsState.isDark
                  ? "assets/images/aivio_logo_white.png"
                  : "assets/images/aivio_logo_black.png",
              scale: 4,
            );
          },
        ),
      ),
      leadingWidth: MediaQuery.of(context).size.width * .25,
      actions: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsetsGeometry.only(
                left: AppSpacing.sm,
                top: AppSpacing.sm,
              ),

              child: GestureDetector(
                onTap: () {
                  context.read<ProfileBloc>().add(
                    ToggleThemeEvent(!state.isDark),
                  );
                  context.read<HomeBloc>().add(ChangeTabEvent(1));
                  context.read<MaintenanceBloc>();
                  context.read<MaintenanceBloc>().add(
                    LoadMaintenanceData(status: ''),
                  );
                },
                child: _buildCustomButton(
                  state.isDark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  false,
                ),
              ),
            );
          },
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
              builder: (context, state) {
                bool hasUnread = false;

                if (state is NotificationLoaded) {
                  hasUnread = state.notifications.any(
                    (notification) => notification.readDate == null,
                  );
                }

                return _buildCustomButton(
                  Icons.notifications_none_rounded,
                  hasUnread,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernRequestCard(
    BuildContext context,
    MaintenanceTicketModel req,
    AppColors colors,
  ) {
    bool isRated = req.averageRating > 0;
    print("The Status is : ${req.averageRating}");
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.inputBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colors.textMain.withOpacity(0.1),
                      borderRadius: AppRadius.smRadius,
                    ),
                    child: Icon(
                      Icons.electrical_services,
                      color: colors.textMain,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    req.name.isNotEmpty ? req.name : "#${req.id}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.bodySmall,
                      color: colors.textMain,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.statusApprovedBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  req.stageName,
                  style: TextStyle(
                    fontSize: 10,
                    color: colors.statusApprovedText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                req.subject,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppFontSizes.bodyMedium,
                  color: colors.textMain,
                ),
              ),
              if (req.state.toLowerCase() == 'waiting_rating' ||
                  req.state.toLowerCase() == 'completed' ||
                  req.state.toLowerCase() == 'closed') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isRated
                        ? Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                "${req.averageRating}",
                                style: TextStyle(
                                  fontSize: AppFontSizes.caption,
                                ),
                              ),
                            ],
                          )
                        : InkWell(
                            onTap: () =>
                                _showRatingDialog(context, colors, req.id),
                            child: Text(
                              "تقييم الخدمة",
                              style: TextStyle(
                                color: colors.textMain,
                                fontSize: AppFontSizes.caption,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ],
          ),
          SizedBox(height: 2),
          Text(
            "${req.categoryName} • الفني: ${req.assignedUserName ?? 'غير محدد'}",
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: AppFontSizes.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingDialog(BuildContext context, AppColors colors, int ticketId) {
    context.read<MaintenanceBloc>().add(UpdateRating(0));
    final TextEditingController feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) =>
          BlocBuilder<MaintenanceBloc, MaintenanceState>(
            builder: (context, state) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.lgRadius,
                  ),
                  title: Text(
                    "تقييم الخدمة",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.headingSmall,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "كيف كانت جودة العمل وسرعة التنفيذ؟",
                        style: TextStyle(fontSize: AppFontSizes.bodyMedium),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          int starValue = index + 1;
                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<MaintenanceBloc>(
                                context,
                              ).add(UpdateRating(starValue));
                            },
                            child: Icon(
                              starValue <= state.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 35,
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      TextField(
                        controller: feedbackController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "أضف ملاحظاتك (اختياري)...",
                          hintStyle: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: colors.textSecondary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.smRadius,
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: AppFontSizes.bodyMedium,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.smRadius,
                        ),
                      ),
                      onPressed: () {
                        BlocProvider.of<MaintenanceBloc>(context).add(
                          RateTicket(
                            ticketId: ticketId,
                            rating: state.rating,
                            feedback: feedbackController.text,
                          ),
                        );
                        Navigator.pop(dialogContext);
                      },
                      child: Text(
                        "إرسال التقييم",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSizes.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    MaintenanceState state,
    AppColors colors,
  ) {
    if (state.isLoading && state.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.categories.isEmpty) {
      return const Center(child: Text("لا توجد فئات صيانة متاحة حالياً"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        final category = state.categories[index];
        final isSelected = state.selectedCategoryId == category.id;

        final categoryIcon = _getIconData(category.icon);
        final categoryColor = _getCategoryColor(category.color, colors);

        return GestureDetector(
          onTap: () =>
              context.read<MaintenanceBloc>().add(SelectCategory(category.id)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              border: Border.all(
                color: isSelected ? colors.primary : colors.inputBorder,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(categoryIcon, color: categoryColor, size: 24),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: AppFontSizes.bodyMedium,
                          fontWeight: FontWeight.bold,
                          color: colors.textMain,
                        ),
                      ),

                      // // يمكنك أيضاً إظهار اسم الفريق أو معلومات إضافية إن أردت
                      // const SizedBox(height: 4),
                      // Text(
                      //   "الفريق المسؤول: ${category.teamName}",
                      //   style: TextStyle(
                      //     fontSize: AppFontSizes.caption - 1,
                      //     color: colors.textSecondary,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected ? colors.primary : colors.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomButton(IconData icon, bool hasNotification) {
    return Container(
      width: AppIconSizes.xl,
      height: AppIconSizes.xl,
      decoration: BoxDecoration(
        color: AppColors().inputFill,
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
          Icon(icon, color: AppColors().textMain, size: AppIconSizes.md),
          if (hasNotification)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors().danger,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase().trim()) {
      case 'water_drop_outlined':
        return Icons.water_drop_outlined;
      case 'air':
        return Icons.air;
      case 'bolt':
        return Icons.bolt;
      case 'unfold_more':
        return Icons.unfold_more;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'build_outlined':
        return Icons.build_outlined;
      case 'plumbing':
        return Icons.plumbing;
      case 'carpenter':
        return Icons.carpenter;
      default:
        return Icons.build_rounded;
    }
  }

  Color _getCategoryColor(int colorCode, AppColors appColors) {
    switch (colorCode) {
      case 5:
        return Colors.purple;
      case 6:
        return Colors.teal;
      case 7:
        return Colors.orange;
      case 8:
        return Colors.indigo;
      case 9:
        return Colors.pink;
      case 10:
        return Colors.cyan;
      case 11:
        return Colors.amber.shade700;
      case 12:
        return Colors.deepOrange;
      case 1:
        return appColors.primary;
      case 2:
        return Colors.blue;
      default:
        return appColors.primary;
    }
  }
}

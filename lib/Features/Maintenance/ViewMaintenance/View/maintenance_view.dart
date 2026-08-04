import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../../Core/UIConstants/aivio_spacing.dart';
import '../../../../Data/Models/maintenance_ticket_model.dart';
import '../../../MainPage/View/main_home_page.dart';
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

  final List<Map<String, String>> _statuses = [
    {'key': 'all', 'label': 'الكل'},
    {'key': 'open', 'label': 'النشطة'},
    {'key': 'completed', 'label': 'المكتملة'},
    {'key': 'cancelled', 'label': 'الملغاة'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<MaintenanceBloc>().add(LoadMaintenanceData(status: 'open'));
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
    final colors = AppColors();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0.0,
          title: Text(
            "الصــيــانــة والــخــدمــات",
            style: TextStyle(
              color: colors.textMain,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.headingSmall,
            ),
          ),
          centerTitle: true,
          automaticallyImplyActions: false,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.menu, size: AppIconSizes.md, color: colors.textMain),
            onPressed: () {
              MainHomePage.drawerController.toggle();
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewMaintenanceRequestView(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(left: AppSpacing.md),
                child: Icon(
                  Icons.add_rounded,
                  size: AppIconSizes.lg,
                  color: colors.primary,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.sm,
              ),
              child: BlocBuilder<MaintenanceBloc, MaintenanceState>(
                builder: (context, state) {
                  return TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      context.read<MaintenanceBloc>().add(SearchMaintenance(query));
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
                      fillColor: Colors.white,
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
                    return const Center(child: CircularProgressIndicator());
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
                    padding: EdgeInsets.all(AppSpacing.md),
                    itemCount:
                    state.tickets.length + (state.isMoreLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.tickets.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final req = state.tickets[index];
                      return _buildModernRequestCard(context, req, colors);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernRequestCard(
      BuildContext context,
      MaintenanceTicketModel req,
      AppColors colors,
      ) {
    bool isRated = req.averageRating > 0;
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.sm),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                      color: colors.primary.withOpacity(0.1),
                      borderRadius: AppRadius.smRadius,
                    ),
                    child: Icon(
                      Icons.electrical_services,
                      color: colors.primary,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    req.name.isNotEmpty ? req.name : "#${req.id}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.caption,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  req.stageName,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.orange.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            req.subject,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.bodyMedium,
              color: colors.textMain,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "${req.categoryName} • الفني: ${req.assignedUserName ?? 'غير محدد'}",
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: AppFontSizes.caption,
            ),
          ),
          if (req.state.toLowerCase() == 'done' ||
              req.state.toLowerCase() == 'completed') ...[
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isRated
                    ? Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      "${req.averageRating}",
                      style: TextStyle(fontSize: AppFontSizes.caption),
                    ),
                  ],
                )
                    : InkWell(
                  onTap: () => _showRatingDialog(context, colors, req.id),
                  child: Text(
                    "تقييم الخدمة",
                    style: TextStyle(
                      color: colors.primary,
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
}
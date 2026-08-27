import 'package:anydrawer/anydrawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as https;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:residential_compound_app/Data/Repositories/home_repository.dart';
import 'package:residential_compound_app/Features/Notification/View/notification_view.dart';
import 'package:residential_compound_app/Features/Profile/View/profile_view.dart';
import '../../../Core/AppConstants/app_constants.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/FormattedDateTime/formatted_price.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../../../Data/Models/announcement_model.dart';
import '../../../Data/Models/user_model.dart';
import '../../../Data/Models/dashboard_data_model.dart';
import '../../../Data/Repositories/community_repository.dart';
import '../../AnnouncementDetails/View/announcement_details_view.dart';
import '../../Community/BLoC/community_bloc.dart';
import '../../Community/BLoC/community_event.dart';
import '../../Community/BLoC/community_state.dart';
import '../../Drawer/View/drawer_view.dart';
import '../../MainPage/BLoC/home_bloc.dart';
import '../../MainPage/BLoC/home_event.dart';

import '../../MainPage/View/main_home_page.dart';
import '../../Maintenance/AddMaintenanceTicket/View/add_new_maintenance_view.dart';
import '../../Visitors/AddNewVisitor/View/add_new_visitor.dart';
import '../BLoC/dashboard_bloc.dart';
import '../BLoC/dashboard_event.dart';
import '../BLoC/dashboard_state.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DashboardBloc(repository: HomeRepository())
                  ..add(FetchDashboardData()),
          ),
          BlocProvider(
            create: (context) =>
                CommunityBloc(repository: CommunityRepository())
                  ..add(LoadAnnouncements()),
          ),
        ],
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: colors.scaffoldBackground,
              appBar: _buildHeader(colors, context),
              body: _buildBody(state, colors, context),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildHeader(
    AppColors colors,
    BuildContext context,
  ) {
    return AppBar(
      backgroundColor: colors.scaffoldBackground,
      title: Text(
        "مــجــمــع آيــفــيــو الــســكــنــي",
        style: TextStyle(
          fontSize: AppFontSizes.headingSmall,
          fontWeight: FontWeight.bold,
          color: colors.textMain,
        ),
      ),
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu, size: AppIconSizes.md, color: colors.textMain),
            onPressed: () async {
              showDrawer(
                context,
                builder: (context) {
                  return AppDrawer();
                },
              );
            },
          );
        },
      ),      actions: [
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationView()),
          ),
          icon: Icon(
            Icons.notifications_none,
            size: AppIconSizes.md,
            color: colors.textMain,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    DashboardState state,
    AppColors colors,
    BuildContext context,
  ) {

    if (state is DashboardLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is DashboardFailure) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: AppIconSizes.xl,
                color: Colors.red.shade400,
              ),
              SizedBox(height: AppSpacing.md),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.bodyLarge,
                  color: colors.textMain,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.lg),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mdRadius,
                  ),
                ),
                onPressed: () {
                  context.read<DashboardBloc>().add(FetchDashboardData());
                },
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  "إعادة المحاولة",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is DashboardLoaded) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDueCard(context, colors, state.homeData),
            SizedBox(height: AppSpacing.lg),
            BlocBuilder<CommunityBloc, CommunityState>(
              builder: (context, communityState) {
                if (communityState.status == CommunityStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (communityState.announcements.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _buildAnnouncementsSlider(
                  communityState.announcements,
                  colors,
                  context,
                );
              },
            ),
            SizedBox(height: AppSpacing.lg),
            _buildQuickServices(colors, context),
            SizedBox(height: AppSpacing.lg),
            _buildRecentInvoices(colors, state.homeData),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildDueCard(
    BuildContext context,
    AppColors colors,
    DashboardDataModel homeData,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgRadius,
        gradient: colors.primaryGradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "المستحقات الحالية",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: AppFontSizes.bodyMedium,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                "${formatNumber(homeData.amountDue)} د.ع",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.displayLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              context.read<HomeBloc>().add(ChangeTabEvent(3));
            },
            child: Text(
              "عرض الفواتير ←",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppFontSizes.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsSlider(
    List<AnnouncementModel> announcements,
    AppColors colors,
    BuildContext context,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: announcements.length,

            itemBuilder: (context, index) {
              final announcement = announcements[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnnouncementDetailsView(
                        announcement: announcement,
                      ),
                    ),
                  );
                  // showModalBottomSheet(
                  //   context: context,
                  //   shape: const RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.vertical(
                  //       top: Radius.circular(20),
                  //     ),
                  //   ),
                  //   builder: (context) {
                  //     return Container(
                  //       padding: EdgeInsets.all(AppSpacing.xl),
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.min,
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             announcement.title,
                  //             style: TextStyle(
                  //               fontSize: AppFontSizes.headingSmall,
                  //               fontWeight: FontWeight.bold,
                  //               color: colors.textMain,
                  //             ),
                  //           ),
                  //           SizedBox(height: AppSpacing.md),
                  //           Text(
                  //             announcement.subtitle,
                  //             style: TextStyle(
                  //               fontSize: AppFontSizes.bodyMedium,
                  //               color: colors.textSecondary,
                  //               height: 1.5,
                  //             ),
                  //           ),
                  //           SizedBox(height: AppSpacing.lg),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.xlRadius,
                    border: Border.all(color: colors.inputBorder),
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.lgRadius,
                    child: announcement.imageUrl.isNotEmpty
                        ? _buildImageWithToken(
                            announcement.imageUrl,
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: AppSpacing.md),
        SmoothPageIndicator(
          controller: _pageController,
          count: announcements.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: colors.primary,
            dotColor: colors.inputBorder,
          ),
        ),
      ],
    );
  }

  Widget _buildImageWithToken(String imageUrl) {
    return FutureBuilder<String?>(
      future: CacheManager.getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (kDebugMode) {
          print("Image URL: $imageUrl");
        }
        return FutureBuilder<https.Response>(
          future: https.get(
            Uri.parse(imageUrl),
            headers: {'Authorization': 'Bearer ${snapshot.data}'},
          ),
          builder: (context, resp) {
            if (resp.hasData && resp.data!.statusCode == 200) {
              return Image.memory(
                resp.data!.bodyBytes,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildRecentInvoices(AppColors colors, DashboardDataModel homeData) {
    if (homeData.recentInvoices.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الفواتير الأخيرة",
            style: TextStyle(
              fontSize: AppFontSizes.bodyLarge,
              fontWeight: FontWeight.bold,
              color: colors.textMain,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          ...homeData.recentInvoices.map(
            (inv) => Container(
              margin: EdgeInsets.only(bottom: AppSpacing.sm),
              padding: EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.mdRadius,
                border: Border.all(color: colors.inputBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    inv.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colors.textMain,
                    ),
                  ),
                  Text(
                    "${formatNumber(inv.amountTotal)} د.ع",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildQuickServices(AppColors colors, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الخدمات السريعة",
          style: TextStyle(
            fontSize: AppFontSizes.bodyLarge,
            fontWeight: FontWeight.bold,
            color: colors.textMain,
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _serviceItem(Icons.qr_code, "تصريح دخول", colors, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNewVisitorView(key: widget.key),
                ),
              );
            }),
            SizedBox(height: AppSpacing.sm),
            _serviceItem(Icons.build_outlined, "طلب صيانة", colors, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewMaintenanceRequestView(key: widget.key),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _serviceItem(
    IconData icon,
    String label,
    AppColors colors,
    VoidCallback onTap,
  ) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.mdRadius,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.bodyMedium,
                fontWeight: FontWeight.normal,
                color: colors.textMain,
              ),
            ),
            Icon(icon, color: colors.primary, size: AppIconSizes.md),
          ],
        ),
      ),
    );
  }
}

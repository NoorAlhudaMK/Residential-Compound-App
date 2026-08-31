import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as https;
import 'package:residential_compound_app/Features/Emergency/View/emergency_view.dart';
import 'package:residential_compound_app/Features/Profile/BLoC/profile_bloc.dart';
import 'package:residential_compound_app/Features/Profile/BLoC/profile_state.dart';
import 'package:residential_compound_app/Features/Visitors/ViewVisitors/View/visitors_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:residential_compound_app/Data/Repositories/home_repository.dart';
import 'package:residential_compound_app/Features/Notification/View/notification_view.dart';
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
import '../../MainPage/BLoC/home_bloc.dart';
import '../../MainPage/BLoC/home_event.dart';

import '../../Maintenance/AddMaintenanceTicket/View/add_new_maintenance_view.dart';
import '../../Notification/BLoC/notification_bloc.dart';
import '../../Notification/BLoC/notification_state.dart';
import '../../Profile/BLoC/profile_event.dart';
import '../../Profile/View/profile_view.dart';
import '../../Support/View/support_view.dart';
import '../BLoC/dashboard_bloc.dart';
import '../BLoC/dashboard_event.dart';
import '../BLoC/dashboard_state.dart';
import 'unit_details_page.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final PageController _pageController = PageController();

  final colors = AppColors();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

  PreferredSizeWidget _buildHeader(AppColors colors, BuildContext context) {
    return AppBar(
      backgroundColor: colors.scaffoldBackground,
      // title: Text(
      //   "مــجــمــع آيــفــيــو الــســكــنــي",
      //   style: TextStyle(
      //     fontSize: AppFontSizes.headingSmall,
      //     fontWeight: FontWeight.bold,
      //     color: colors.textMain,
      //   ),
      // ),
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
      // Builder(
      //   builder: (context) {
      //     return IconButton(
      //       icon: Icon(
      //         Icons.menu,
      //         size: AppIconSizes.md,
      //         color: colors.textMain,
      //       ),
      //       onPressed: () async {
      //         showDrawer(
      //           context,
      //           builder: (context) {
      //             return AppDrawer();
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),
      actions: [
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsetsGeometry.only(
                left: AppSpacing.sm,
                top: AppSpacing.sm,
              ),
              child: GestureDetector(
                onTap: () async {
                  context.read<ProfileBloc>().add(
                    ToggleThemeEvent(!state.isDark),
                  );
                  await CacheManager.saveThemeMode(isDark: state.isDark);
                  context.read<HomeBloc>().add(ChangeTabEvent(0));
                  context.read<DashboardBloc>().add(FetchDashboardData());
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
          padding: EdgeInsets.all(AppSpacing.sm),
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
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppSpacing.sm),
            _buildHeaderAndUnitCard(colors, context, state.user),
            SizedBox(height: AppSpacing.lg),
            _buildDueCard(context, colors, state.homeData),
            SizedBox(height: AppSpacing.lg),
            // BlocBuilder<CommunityBloc, CommunityState>(
            //   builder: (context, communityState) {
            //     if (communityState.status == CommunityStatus.loading) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     if (communityState.announcements.isEmpty) {
            //       return const SizedBox.shrink();
            //     }
            //     return _buildAnnouncementsSlider(
            //       communityState.announcements,
            //       colors,
            //       context,
            //     );
            //   },
            // ),
            // SizedBox(height: AppSpacing.lg),
            _buildQuickServices(colors, context),
            SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 3,
                      height: AppFontSizes.headingMedium,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      "نشط الآن",
                      style: TextStyle(
                        fontSize: AppFontSizes.headingMedium,
                        fontWeight: FontWeight.bold,
                        color: colors.textMain,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text(
                        'عرض الكل',
                        style: TextStyle(
                          color: colors.textAppBar,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_back_ios,
                        size: 14,
                        color: colors.textAppBar,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildAirConditionerCard(),
            const SizedBox(height: 12),

            _buildDeliveryCard(),
            const SizedBox(height: 12),

            _buildCompoundNoticeCard(),
          //  _buildRecentInvoices(colors, state.homeData),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildHeaderAndUnitCard(
    AppColors colors,
    BuildContext context,
    UserModel homeData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "مجمع AIVIO • المبنى ${homeData.residentProfiles[0].primaryUnit.buildingName}",
                  style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "مساء الخير، ${homeData.name}",
                  style: TextStyle(
                      fontSize: AppFontSizes.headingLarge,
                    fontWeight: FontWeight.bold,
                    color: colors.textAppBar,
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    homeData.name.substring(0, 2).toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                        fontSize: AppFontSizes.bodyLarge,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: AssetImage('assets/images/unit_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  colors.primary.withOpacity(0.95),
                  colors.primary.withOpacity(0.4),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.apartment_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "RESIDENT HOME",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                          fontSize: AppFontSizes.bodySmall,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "الشقة ${homeData.residentProfiles[0].primaryUnit.name}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.displaySmall,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${homeData.residentProfiles[0].residentType} • ${homeData.residentProfiles[0].primaryUnit.state} ",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                          fontSize: AppFontSizes.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UnitDetailsPage(
                              unit: homeData.residentProfiles[0].primaryUnit,
                              owner: homeData.name,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "عرض الوحدة",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.bodyMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDueCard(
    BuildContext context,
    AppColors colors,
    DashboardDataModel homeData,
  ) {
    double unPaidInvoices = 0;
    String payDueDate = '';
    print("الحالةةةة : " + homeData.recentInvoices.length.toString());

    for (int i = 0; i < homeData.recentInvoices.length; i++) {
      print("الحالةةةة : " + homeData.recentInvoices[i].paymentState);
      unPaidInvoices += homeData.recentInvoices[i].amountTotal;
      payDueDate = homeData.recentInvoices[i].dueDate!;
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgRadius,
        color: colors.inputFill,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- القسم العلوي ----------------
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(color: colors.primary),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      "الرصيد المستحق",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.bodyLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(AppSpacing.xs),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2C499),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${homeData.recentInvoices.length}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ---------------- القسم السفلي ----------------
          Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${formatNumber(homeData.amountDue)} د.ع ",
                            style: TextStyle(
                              color: colors.textMain,
                              fontSize: AppFontSizes.displaySmall,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          homeData.recentInvoices.isNotEmpty
                              ? Text(
                                  "$unPaidInvoices فاتورة غير مدفوعة • الاستحقاق ${payDueDate} ",
                                  style: TextStyle(
                                    color: colors.textSecondary,
                                    fontSize: AppFontSizes.bodySmall,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.2,
                    //   height: MediaQuery.of(context).size.width * 0.1,
                    //   child: CustomPaint(painter: HalfCirclePainter()),
                    // ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.mdRadius,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                        ),
                        child: Text(
                          "ادفع الآن",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(ChangeTabEvent(3));
                        },
                        child: Text(
                          "عرض الفواتير",
                          style: TextStyle(
                            color: colors.textAppBar,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
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
                      builder: (context) =>
                          AnnouncementDetailsView(announcement: announcement),
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
                        ? _buildImageWithToken(announcement.imageUrl)
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 3,
              height: AppFontSizes.headingMedium,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              "في خدمتك",
              style: TextStyle(
                fontSize: AppFontSizes.headingMedium,
                fontWeight: FontWeight.bold,
                color: colors.textMain,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          childAspectRatio: 1,
          children: [
            _serviceCard(
              icon: Icons.build_outlined,
              iconColor: Color(0xFF1E5631),
              title: "طلب خدمة",
              colors: colors,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewMaintenanceRequestView(key: widget.key),
                  ),
                );
              },
            ),
            _serviceCard(
              icon: Icons.person_add_outlined,
              title: "الزوار",
              iconColor: Color(0xFF8B6932),
              colors: colors,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisitorView(key: widget.key),
                  ),
                );
              },
            ),
            _serviceCard(
              icon: Icons.payments_outlined,
              iconColor: Color(0xFFB84A39),
              title: "الفواتير",
              colors: colors,
              onTap: () {
                context.read<HomeBloc>().add(ChangeTabEvent(3));
              },
            ),
            _serviceCard(
              icon: Icons.card_travel_outlined,
              iconColor: Color(0xFF8B6932),
              title: "تسوق",
              colors: colors,
              onTap: () {
                context.read<HomeBloc>().add(ChangeTabEvent(2));
              },
            ),
            _serviceCard(
              icon: Icons.warning_amber_rounded,
              title: "طوارئ",
              iconColor: Color(0xFFB84A39),
              colors: colors,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmergencyScreen(key: widget.key),
                  ),
                );
              },
            ),
            _serviceCard(
              icon: Icons.chat_bubble_outline,
              iconColor: Color(0xFF2C5E4B),
              title: "الدعم",
              colors: colors,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupportCenterScreen(key: widget.key),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _serviceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required AppColors colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: colors.inputFill,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: AppRadius.lg,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: AppIconSizes.lg, color: iconColor),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.bodyMedium,
                fontWeight: FontWeight.w700,
                color: colors.textMain,
              ),
            ),
          ],
        ),
      ),
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

  /// Missing Parts ...

  Widget _buildAirConditionerCard() {
    return Container(
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 150,
                color: Colors.grey,
                child: const Image(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=300&auto=format&fit=crop',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: colors.statusArrivedText,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'قيد التنفيذ',
                          style: TextStyle(
                            color: colors.statusArrivedText,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'تكييف الهواء',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyLarge,
                        fontWeight: FontWeight.bold,
                        color: colors.textMain,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الفني في الطريق',
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: colors.textSecondary),
                        SizedBox(width: 4),
                        Text(
                          'الوصول خلال 18 دقيقة تقريباً',
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // السهم الجانبي
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(Icons.arrow_back_ios_new_outlined, size: 16, color: colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // أيقونة الصندوق
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: colors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'التوصيل',
                  style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'AIVIO Market',
                  style: TextStyle(
                      fontSize: AppFontSizes.headingSmall,
                    fontWeight: FontWeight.bold,
                    color: colors.textMain,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'يتم تجهيز طلبك',
                  style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // السهم الجانبي
          Icon(Icons.arrow_back_ios_new_outlined, size: 16, color: colors.textSecondary,),
        ],
      ),
    );
  }

  Widget _buildCompoundNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.inputFill,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF4F1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.apartment_rounded,
              color: colors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'إشعار المجمع',
                  style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                 Text(
                  'صيانة لخدمة المياه يوم الخميس، من 10:00 إلى 13:00.',
                  style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                    color: colors.textMain,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'قراءة المزيد',
                        style: TextStyle(
                          color: colors.textAppBar,
                          fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.bodySmall,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_back,
                        size: 14,
                        color: colors.textAppBar,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

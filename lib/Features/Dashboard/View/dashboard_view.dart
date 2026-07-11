import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Data/Repositories/home_repository.dart';
import 'package:residential_compound_app/Features/Notification/View/notification_view.dart';
import 'package:residential_compound_app/Features/Profile/View/profile_view.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/user_model.dart';
import '../../../Data/Models/dashboard_data_model.dart';
import '../BLoC/dashboard_bloc.dart';
import '../BLoC/dashboard_event.dart';
import '../BLoC/dashboard_state.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        body: SafeArea(
          child: BlocProvider(
            create: (context) =>
                DashboardBloc(repository: HomeRepository())
                  ..add(FetchDashboardData()),
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DashboardLoaded) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(colors, state.user, context),
                        const SizedBox(height: 20),
                        _buildAnnoucementBar(colors),
                        const SizedBox(height: 25),
                        _buildDueCard(colors, state.homeData),
                        const SizedBox(height: 30),
                        _buildSecurityStatus(colors),
                        const SizedBox(height: 30),
                        _buildQuickServices(colors),
                        const SizedBox(height: 30),
                        _buildRecentInvoices(colors, state.homeData),
                      ],
                    ),
                  );
                }
                if (state is DashboardFailure) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColors colors, UserModel user, BuildContext context) {
    final profile = user.residentProfiles.isNotEmpty
        ? user.residentProfiles.first
        : null;
    final unitInfo = profile != null
        ? "${profile.primaryUnit.name}، ${profile.primaryUnit.buildingName}"
        : "لا توجد وحدة مسجلة";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         GestureDetector(
           onTap: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => ProfileView(
                 username: profile!.name,
                 buildingName:  user.residentProfiles.first.name,
                 apartmentNumber: profile.primaryUnit.name,
               ),
               ),
             );
           },
           child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 30),
                   ),
         ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مرحباً، ${user.name}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            // Row(
            //   children: [
            //     Icon(Icons.circle, size: 8, color: colors.goldAccent),
            //     const SizedBox(width: 5),
            //     Text(
            //       unitInfo,
            //       style: TextStyle(color: colors.textSecondary, fontSize: 13),
            //     ),
            //   ],
            // ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationView()),
            );
            },
          child: Icon(
            Icons.notifications,
          ),
        ),
      ],
    );
  }

  Widget _buildDueCard(AppColors colors, DashboardDataModel homeData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [colors.primary, const Color(0xFF1E4D92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "المستحقات الحالية",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                "${homeData.amountDue} ",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                "د.ع ",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentInvoices(AppColors colors, DashboardDataModel homeData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "الفواتير الأخيرة",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        ...homeData.recentInvoices.map(
          (inv) => Card(
            child: ListTile(
              title: Text(inv.name),
              subtitle: Text("المبلغ: ${inv.amountTotal}"),
              trailing: Text(inv.paymentState),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickServices(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "الخدمات السريعة",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _quickServiceItem(
              Icons.qr_code_scanner,
              "تصريح دخول",
              const Color(0xFFE0F2FE),
              Colors.blue,
            ),
            _quickServiceItem(
              Icons.build_outlined,
              "طلب صيانة",
              const Color(0xFFF1F5F9),
              Colors.grey,
            ),
            _quickServiceItem(
              Icons.calendar_month_outlined,
              "حجز مرفق",
              const Color(0xFFF5F3FF),
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickServiceItem(
    IconData icon,
    String label,
    Color bg,
    Color iconColor,
  ) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 30),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildAnnoucementBar(AppColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              minimumSize: const Size(60, 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "تحديث",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "سيتم قطع المياه للصيانة غداً من 9 صباحاً",
              style: TextStyle(fontSize: 11),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityStatus(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "حالة الأمن",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.inputBorder),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user, color: Colors.green),
              ),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "البوابة الرئيسية آمنة",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "آخر تحديث: منذ 5 دقائق",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
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
            create: (context) => DashboardBloc()..add(FetchDashboardData()),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(colors),
                  const SizedBox(height: 20),
                  _buildAnnoucementBar(colors),
                  const SizedBox(height: 25),
                  _buildDueCard(colors),
                  const SizedBox(height: 30),
                  _buildSecurityStatus(colors),
                  const SizedBox(height: 30),
                  _buildQuickServices(colors),
                  const SizedBox(height: 30),
                  _buildUpcomingActivities(colors),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 1. الرأس (Header)
  Widget _buildHeader(AppColors colors) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'), // استبدليها بصورة المستخدم
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("مرحباً، أشرف", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.primary)),
            Row(
              children: [
                Icon(Icons.circle, size: 8, color: colors.goldAccent),
                const SizedBox(width: 5),
                Text("شقة 304، برج أوركيد", style: TextStyle(color: colors.textSecondary, fontSize: 13)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // 2. بطاقة المستحقات (Due Card) بتدرج لوني
  Widget _buildDueCard(AppColors colors) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
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
              Text("المستحقات الحالية", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text("1,250", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 5),
                  Text("ر.س", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16)),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.white.withOpacity(0.2)),
              const SizedBox(height: 10),
              Text("يستحق في: 15 أكتوبر 2023", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13)),
            ],
          ),
        );
      },
    );
  }

  // 3. الخدمات السريعة (Quick Services)
  Widget _buildQuickServices(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("الخدمات السريعة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _quickServiceItem(Icons.qr_code_scanner, "تصريح دخول", const Color(0xFFE0F2FE), Colors.blue),
            _quickServiceItem(Icons.build_outlined, "طلب صيانة", const Color(0xFFF1F5F9), Colors.grey),
            _quickServiceItem(Icons.calendar_month_outlined, "حجز مرفق", const Color(0xFFF5F3FF), Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _quickServiceItem(IconData icon, String label, Color bg, Color iconColor) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 30),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // 4. النشاطات القادمة (تصميم مقترح)
  Widget _buildUpcomingActivities(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("نشاطات قادمة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoaded) {
              return Column(
                children: state.activities.map((act) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.inputBorder.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: colors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text(act['date'].split(' ')[0], style: TextStyle(fontWeight: FontWeight.bold, color: colors.primary)),
                            Text(act['date'].split(' ')[1], style: TextStyle(fontSize: 10, color: colors.primary)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(act['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(act['time'], style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    ],
                  ),
                )).toList(),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }

  // بار الإعلانات/التنبيهات العلوي
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("تحديث", style: TextStyle(fontSize: 10, color: Colors.white)),
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
        const Text("حالة الأمن", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.verified_user, color: Colors.green),
              ),
              const SizedBox(width: 15),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("البوابة الرئيسية آمنة", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("آخر تحديث: منذ 5 دقائق", style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
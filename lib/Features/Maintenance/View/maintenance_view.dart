import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Core/Colors/app_colors.dart';
import '../BLoC/maintenance_bloc.dart';
import '../BLoC/maintenance_event.dart';
import '../BLoC/maintenance_state.dart';
import 'add_new_maintenance_view.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return BlocProvider(
      create: (context) => MaintenanceBloc()..add(LoadMaintenanceData()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text("الصيانة والخدمات",
                style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: () => _navigateToNewRequest(context),
                  child: CircleAvatar(
                    backgroundColor: colors.primary,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          body: BlocBuilder<MaintenanceBloc, MaintenanceState>(
            builder: (context, state) {
              if (state.isLoading) return const Center(child: CircularProgressIndicator());

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceCategories(colors),
                    const SizedBox(height: 30),
                    _buildSectionTitle("الطلبات النشطة"),
                    const SizedBox(height: 15),
                    ...state.activeRequests.map((req) => _buildActiveRequestCard(req, colors)),
                    const SizedBox(height: 30),
                    _buildSectionTitle("الطلبات السابقة"),
                    const SizedBox(height: 15),
                    ...state.pastRequests.map((req) => _buildPastRequestCard(context, req, colors)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _navigateToNewRequest(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewMaintenanceRequestView()),
    );
  }

  void _showRatingDialog(BuildContext context, AppColors colors) {
    context.read<MaintenanceBloc>().add(UpdateRating(0));

    showDialog(
      context: context,
      builder: (context) => BlocBuilder<MaintenanceBloc, MaintenanceState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text("تقييم الخدمة",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("كيف كانت جودة العمل وسرعة التنفيذ؟"),
                  const SizedBox(height: 20),
                  // صف النجوم التفاعلي
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      int starValue = index + 1;
                      return GestureDetector(
                        onTap: () {
                          context.read<MaintenanceBloc>().add(UpdateRating(starValue));
                        },
                        child: Icon(
                          starValue <= state.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 35,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "أضف ملاحظاتك (اختياري)...",
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("إلغاء", style: TextStyle(color: Colors.grey))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    // هنا يمكنك إرسال التقييم المخزن في state.rating للسيرفر
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("شكراً لتقييمك: ${state.rating} نجوم")),
                    );
                  },
                  child: const Text("إرسال التقييم", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceCategories(AppColors colors) {
    final services = [
      {"name": "كهرباء", "icon": Icons.bolt, "color": Colors.orange},
      {"name": "تكييف", "icon": Icons.ac_unit, "color": Colors.cyan},
      {"name": "مصاعد", "icon": Icons.unfold_more, "color": Colors.indigo},
      {"name": "نظافة", "icon": Icons.auto_awesome, "color": Colors.green},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: services.map((s) => Column(
        children: [
          Container(
            width: 75, height: 75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
            ),
            child: Icon(s['icon'] as IconData, color: (s['color'] as Color).withOpacity(0.7), size: 28),
          ),
          const SizedBox(height: 8),
          Text(s['name'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      )).toList(),
    );
  }

  Widget _buildActiveRequestCard(Map<String, dynamic> req, AppColors colors) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.ac_unit, color: Colors.cyan, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(req['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("${req['time']} • #${req['id']}", style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildStep(true, "تم استلام الطلب", null),
          _buildStep(true, "تم التعيين", "الفني: ${req['techName']}"),
          _buildStep(false, "قيد الإنجاز", null, isLast: true),
        ],
      ),
    );
  }

  Widget _buildStep(bool isDone, String title, String? subtitle, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFF102C57) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: isDone ? const Color(0xFF102C57) : Colors.grey.shade300),
              ),
              child: isDone ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
            if (!isLast) Container(width: 2, height: 30, color: isDone ? const Color(0xFF102C57) : Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: isDone ? Colors.black : Colors.grey, fontWeight: isDone ? FontWeight.bold : FontWeight.normal)),
            if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildPastRequestCard(BuildContext context, Map<String, dynamic> req, AppColors colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), shape: BoxShape.circle),
            child: const Icon(Icons.water_drop_outlined, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(req['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(req['date'], style: TextStyle(color: colors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showRatingDialog(context, colors),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text("تقييم الخدمة",
                    style: TextStyle(fontSize: 10, color: colors.primary, decoration: TextDecoration.underline)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }
}
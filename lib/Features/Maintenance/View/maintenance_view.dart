import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Data/Models/maintenance_ticket_model.dart';
import '../../../Data/Models/status_model.dart';
import '../../../Data/Repositories/maintenance_repository.dart';
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
      create: (context) => MaintenanceBloc(repository: MaintenanceRepository())..add(LoadMaintenanceData()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text("الصيانة والخدمات", style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold)),
            centerTitle: true,
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
                child: Icon(
                    Icons.add,
                  color: colors.primary,
                ),
              ),
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
                    _buildSectionTitle("الطلبات النشطة"),
                    const SizedBox(height: 15),
                    state.activeRequests.isEmpty
                        ? const Center(child: Text("لا توجد طلبات نشطة"))
                        : Column(children: state.activeRequests.map((req) => _buildActiveRequestCard(req, colors, state.statuses)).toList()),

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

  Widget _buildActiveRequestCard(MaintenanceTicketModel req, AppColors colors, List<StatusModel> statuses) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.ac_unit, color: Colors.cyan, size: 20)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(req.subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("${req.categoryName} • #${req.id}", style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                  Text("${req.description}", style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildStatusStepper(statuses, req.stageName),
        ],
      ),
    );
  }

  Widget _buildStatusStepper(List<StatusModel> allStatuses, String currentStageName) {
    final sortedStatuses = List<StatusModel>.from(allStatuses)..sort((a, b) => a.sequence.compareTo(b.sequence));
    final currentIndex = sortedStatuses.indexWhere((s) => s.name.toLowerCase() == currentStageName.toLowerCase());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sortedStatuses.map((status) {
        final statusIndex = sortedStatuses.indexOf(status);
        final isCompleted = statusIndex < currentIndex;
        final isCurrent = statusIndex == currentIndex;
        final isLast = statusIndex == sortedStatuses.length - 1;

        return Row(
          children: [
            Column(
              children: [
                Container(
                  width: 25, height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? Colors.green : (isCurrent ? Colors.blue : Colors.grey[300]),
                    border: isCurrent ? Border.all(color: Colors.blue.shade100, width: 4) : null,
                  ),
                  child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
                if (!isLast) Container(width: 2, height: 25, color: Colors.grey[300]),
              ],
            ),
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Text(
                status.name,
                style: TextStyle(
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    color: isCurrent ? Colors.blue : (isCompleted ? Colors.black : Colors.grey)
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildPastRequestCard(BuildContext context, MaintenanceTicketModel req, AppColors colors) {
    bool isRated = req.averageRating > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Row(
        children: [
          const Icon(Icons.history, color: Colors.blue, size: 20),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(req.subject, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(req.stageName, style: TextStyle(color: colors.textSecondary, fontSize: 11)),
          ])),
          isRated
              ? Row(children: [const Icon(Icons.star, color: Colors.amber, size: 16), Text("${req.averageRating}")])
              : InkWell(onTap: () => _showRatingDialog(context, colors, req.id), child: Text("تقييم", style: TextStyle(color: colors.primary, decoration: TextDecoration.underline))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

  void _showRatingDialog(BuildContext context, AppColors colors, int ticketId) {
    context.read<MaintenanceBloc>().add(UpdateRating(0));
    final TextEditingController feedbackController = TextEditingController();
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
                    context.read<MaintenanceBloc>().add(RateTicket(
                      ticketId: ticketId,
                      rating: state.rating, // يجب ربطها بـ state.rating
                      feedback: feedbackController.text,
                    ));
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
}

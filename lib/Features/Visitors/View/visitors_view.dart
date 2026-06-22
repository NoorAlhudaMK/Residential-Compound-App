import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Core/Colors/app_colors.dart';
import '../BLoC/visitors_bloc.dart';
import '../BLoC/visitors_event.dart';
import '../BLoC/visitors_state.dart';

class VisitorView extends StatefulWidget {
  const VisitorView({super.key});

  @override
  State<VisitorView> createState() => _VisitorViewState();
}

class _VisitorViewState extends State<VisitorView> {
  final ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController nameController = TextEditingController();

  String selectedRelation = "صديق";
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  bool hasCar = false;
  int companionsCount = 0;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return BlocProvider(
      create: (context) => VisitorBloc(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "الأمن والزوار",
              style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            automaticallyImplyActions: false,
          ),
          body: BlocBuilder<VisitorBloc, VisitorState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildToggleTabs(colors, context, state),
                    const SizedBox(height: 30),
                    if (state.activeTab == 1) ...[
                      if (state.generatedVisitorName != null)
                        _buildActivePermitCard(colors, state),
                      const SizedBox(height: 30),
                      _buildNewPermitForm(colors, context, state),
                    ] else
                      _buildVisitHistory(colors, state),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTabs(AppColors colors, BuildContext context, VisitorState state) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _tabButton("إنشاء تصريح", state.activeTab == 1,
                  () => context.read<VisitorBloc>().add(ToggleTab(1))),
          _tabButton("سجل الزيارات", state.activeTab == 0,
                  () => context.read<VisitorBloc>().add(ToggleTab(0))),
        ],
      ),
    );
  }

  Widget _tabButton(String title, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)] : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? const Color(0xFF102C57) : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivePermitCard(AppColors colors, VisitorState state) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Container(height: 5, width: 80, decoration: const BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)))),
          const SizedBox(height: 20),
          const Text("تصريح دخول نشط", style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.bold)),
          Text(state.generatedVisitorName ?? "", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          Screenshot(
            controller: screenshotController,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: QrImageView(
                data: state.qrCodeData ?? "",
                version: QrVersions.auto,
                size: 180.0,
                eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF102C57)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF102C57),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () => _handleShare(state.generatedVisitorName!),
              icon: const Icon(Icons.share_outlined, color: Colors.white),
              label: const Text("مشاركة التصريح", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPermitForm(AppColors colors, BuildContext context, VisitorState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("تفاصيل الزيارة القادمة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        _label("اسم الزائر الثلاثي"),
        TextField(
          controller: nameController,
          decoration: _inputStyle("أدخل اسم الزائر..."),
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(child: _buildDatePicker(context)),
            const SizedBox(width: 12),
            Expanded(child: _buildTimePicker(context)),
          ],
        ),

        const SizedBox(height: 20),

        _buildDropdownField("صلة القرابة", ["صديق", "عائلة", "مندوب توصيل"]),

        const SizedBox(height: 15),

        Row(
          children: [
            Checkbox(
              value: hasCar,
              onChanged: (val) => setState(() => hasCar = val!),
              activeColor: colors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            const Text("الزائر يمتلك سيارة", style: TextStyle(fontSize: 14)),
          ],
        ),

        const SizedBox(height: 10),

        _label("عدد المرافقين"),
        Row(
          children: [
            _counterBtn(Icons.remove, () => setState(() => companionsCount > 0 ? companionsCount-- : null)),
            Container(
              width: 50,
              alignment: Alignment.center,
              child: Text("$companionsCount", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _counterBtn(Icons.add, () => setState(() => companionsCount++)),
          ],
        ),

        const SizedBox(height: 35),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 0,
            ),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<VisitorBloc>().add(GeneratePermit(nameController.text));
                FocusScope.of(context).unfocus();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى كتابة اسم الزائر أولاً")));
              }
            },
            child: state.isGenerating
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text("توليد كود الدخول", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF475569))),
  );

  InputDecoration _inputStyle(String hint) => InputDecoration(
    hintText: hint,
    fillColor: Colors.white,
    filled: true,
    hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFF1F5F9))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.blue, width: 1.5)),
  );

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFF1F5F9))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedRelation,
              isExpanded: true,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: (val) => setState(() => selectedRelation = val!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("التاريخ *"),
        InkWell(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2027),
            );
            if (picked != null) setState(() => selectedDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFF1F5F9))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(intl.DateFormat('yyyy/MM/dd').format(selectedDate), style: const TextStyle(fontSize: 13)),
                const Icon(Icons.calendar_month, size: 18, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("الوقت (اختياري)"),
        InkWell(
          onTap: () async {
            TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
            if (picked != null) setState(() => selectedTime = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFF1F5F9))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime != null ? selectedTime!.format(context) : "-- : --",
                  style: TextStyle(fontSize: 13, color: selectedTime != null ? Colors.black : Colors.grey),
                ),
                const Icon(Icons.access_time, size: 18, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFF1F5F9))),
        child: Icon(icon, size: 18, color: const Color(0xFF102C57)),
      ),
    );
  }

  Future<void> _handleShare(String visitorName) async {
    try {
      final Uint8List? image = await screenshotController.capture();
      if (image != null) {
        String timeInfo = selectedTime != null ? " الساعة ${selectedTime!.format(context)}" : "";
        final directory = await getTemporaryDirectory();
        final file = await File('${directory.path}/visitor_permit.png').writeAsBytes(image);

        await Share.shareXFiles(
            [XFile(file.path)],
            text: 'تصريح دخول زائر للمجمع السكني:\nالاسم: $visitorName\nالتاريخ: ${intl.DateFormat('yyyy/MM/dd').format(selectedDate)}$timeInfo\nالمرافقين: $companionsCount'
        );
      }
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  Widget _buildVisitHistory(AppColors colors, VisitorState state) {
    if (state.visitHistory.isEmpty) {
      return _buildEmptyState(colors);
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.visitHistory.length,
      itemBuilder: (context, index) {
        final visit = state.visitHistory[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(visit['icon'], color: colors.primary, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(visit['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text("${visit['type']} • ${visit['time']}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              _buildStatusBadge(visit['status']),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor = const Color(0xFFF1F5F9);
    Color textColor = const Color(0xFF475569);
    if (status == "تم الدخول") {
      bgColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF166534);
    }
    if (status == "زيارة منتظرة") {
      bgColor = const Color(0xFFD1C3D1);
      textColor = const Color(0xFF601665);
    }
    if (status == "ملغي") {
      bgColor = const Color(0xFFFFD9D9);
      textColor = const Color(0xFFF11240);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Text(status, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyState(AppColors colors) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Icon(Icons.history_outlined, size: 80, color: Colors.grey.withOpacity(0.2)),
        const SizedBox(height: 15),
        const Text("لا توجد سجلات حالياً", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
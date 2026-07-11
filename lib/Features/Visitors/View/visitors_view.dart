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
import '../../../Data/Repositories/visitor_repository.dart';
import '../BLoC/visitors_bloc.dart';
import '../BLoC/visitors_event.dart';
import '../BLoC/visitors_state.dart';

class VisitorView extends StatelessWidget {
  final ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(
    text: "07700000000",
  );
  final TextEditingController carPlateController = TextEditingController(
    text: "ABC123",
  );

  VisitorView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocProvider(
      create: (context) =>
          VisitorBloc(repository: VisitorRepository())..add(FetchVisitors()),
      child: BlocBuilder<VisitorBloc, VisitorState>(
        builder: (context, state) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: colors.scaffoldBackground,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  "الأمن والزوار",
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildToggleTabs(colors, context, state),
                    const SizedBox(height: 30),
                    if (state.activeTab == 1) ...[
                      if (state.lastCreatedVisitor != null) ...[
                        _buildActivePermitCard(colors, state, context),
                        const SizedBox(height: 30),
                      ],
                      _buildNewPermitForm(colors, context, state),
                    ] else ...[
                      _buildVisitHistory(colors, state),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVisitHistory(AppColors colors, VisitorState state) {
    if (state.visitHistory.isEmpty) return _buildEmptyState(colors);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.visitHistory.length,
      itemBuilder: (context, index) {
        final visit = state.visitHistory[index];
        print("جاري عرض الزائر رقم: $index");
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
                child: Icon(
                  Icons.person_outline,
                  color: colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visit.visitorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${visit.visitType} • ${visit.visitDatetime}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(visit.status),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'approved':
        backgroundColor = AppColors.statusApprovedBg;
        textColor = AppColors.statusApprovedText;
        break;
      case 'arrived':
      case 'checked_in':
        backgroundColor = AppColors.statusArrivedBg;
        textColor = AppColors.statusArrivedText;
        break;
      default:
        backgroundColor = AppColors.statusDefaultBg;
        textColor = AppColors.statusDefaultText;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildToggleTabs(
    AppColors colors,
    BuildContext context,
    VisitorState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _tabButton(
            "إنشاء تصريح",
            state.activeTab == 1,
            () => context.read<VisitorBloc>().add(ToggleTab(1)),
          ),
          _tabButton(
            "سجل الزيارات",
            state.activeTab == 0,
            () => context.read<VisitorBloc>().add(ToggleTab(0)),
          ),
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

  Widget _buildDateTimePicker(BuildContext context, VisitorState state) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: state.selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2027),
              );
              if (picked != null)
                context.read<VisitorBloc>().add(UpdateDate(picked));
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: Text(
                intl.DateFormat('yyyy/MM/dd').format(state.selectedDate),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(BuildContext context, VisitorState state) {
    final List<String> options = ["صديق", "عائلة", "مندوب توصيل"];

    final String? currentValue = options.contains(state.relation)
        ? state.relation
        : options.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("صلة القرابة"),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            items: options
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                context.read<VisitorBloc>().add(UpdateRelation(val));
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivePermitCard(
    AppColors colors,
    VisitorState state,
    BuildContext context,
  ) {
    final visitor = state.lastCreatedVisitor!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Text(
            visitor.visitorName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Screenshot(
            controller: screenshotController,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              child: QrImageView(data: visitor.qrToken, size: 180.0),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _shareQrCode, // استدعاء ميثود المشاركة
            icon: const Icon(Icons.share),
            label: const Text("مشاركة التصريح"),
            style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPermitForm(
    AppColors colors,
    BuildContext context,
    VisitorState state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("اسم الزائر الثلاثي"),
        TextField(
          controller: nameController,
          decoration: _inputStyle("أدخل اسم الزائر..."),
        ),
        const SizedBox(height: 15),
        _label("التاريخ"),
        _buildDateTimePicker(context, state),
        const SizedBox(height: 15),
        _buildDropdownField(context, state),
        const SizedBox(height: 15),
        Row(
          children: [
            Checkbox(
              value: state.hasCar,
              onChanged: (val) =>
                  context.read<VisitorBloc>().add(UpdateHasCar(val!)),
              activeColor: colors.primary,
            ),
            const Text("الزائر يمتلك سيارة"),
          ],
        ),
        if (state.hasCar) ...[
          _label("رقم لوحة السيارة"),
          TextField(
            controller: carPlateController,
            decoration: _inputStyle("رقم اللوحة"),
          ),
        ],
        _label("عدد المرافقين"),
        Row(
          children: [
            _counterBtn(
              Icons.remove,
              () => context.read<VisitorBloc>().add(
                UpdateCompanions(
                  state.companionsCount > 0 ? state.companionsCount - 1 : 0,
                ),
              ),
            ),
            Text(
              "${state.companionsCount}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _counterBtn(
              Icons.add,
              () => context.read<VisitorBloc>().add(
                UpdateCompanions(state.companionsCount + 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 35),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            minimumSize: const Size(double.infinity, 55),
          ),
          onPressed: () {
            final dateFormat = intl.DateFormat('yyyy-MM-dd HH:mm:ss');

            context.read<VisitorBloc>().add(
              CreateVisitor(
                name: nameController.text,
                phone: phoneController.text,
                unitId: 1,
                validFrom: dateFormat.format(DateTime.now()),
                validTo: dateFormat.format(state.selectedDate),
                hasCar: state.hasCar,
                carPlate: state.hasCar ? carPlateController.text : "",
              ),
            );

            nameController.clear();
            phoneController.clear();
            carPlateController.clear();

            FocusScope.of(context).unfocus();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم إضافة الزائر بنجاح")),
            );
          },
          child: state.isGenerating
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("توليد كود الدخول"),
        ),
      ],
    );
  }

  Future<void> _shareQrCode() async {
    final image = await screenshotController.capture();
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/qr_permit.png').create();
      await imagePath.writeAsBytes(image);
      await Share.shareXFiles([
        XFile(imagePath.path),
      ], text: 'إليك تصريح دخول الزائر');
    }
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );

  InputDecoration _inputStyle(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
  );

  Widget _counterBtn(IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(padding: const EdgeInsets.all(8), child: Icon(icon)),
  );

  Widget _buildEmptyState(AppColors colors) =>
      const Center(child: Text("لا توجد سجلات"));
}

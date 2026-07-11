import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../BLoC/maintenance_bloc.dart';
import '../BLoC/maintenance_event.dart';
import '../BLoC/maintenance_state.dart';

class NewMaintenanceRequestView extends StatelessWidget {
  const NewMaintenanceRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF102C57), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "طلب صيانة جديد",
            style: TextStyle(color: Color(0xFF102C57), fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<MaintenanceBloc, MaintenanceState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "املأ التفاصيل التالية وسنرسل أحد الفنيين في أقرب وقت",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 25),

                  // 1. نوع الصيانة
                  _buildStepHeader("1", "نوع الصيانة", isRequired: true),
                  const SizedBox(height: 15),
                  _buildServiceGrid(context, state),

                  const SizedBox(height: 30),

                  // 2. وصف المشكلة
                  _buildStepHeader("2", "وصف المشكلة", isRequired: true),
                  const SizedBox(height: 15),
                  _buildDescriptionField(context, state),

                  const SizedBox(height: 30),

                  // 3. إرفاق صورة
                  _buildStepHeader("3", "إرفاق صورة", isOptional: true),
                  const SizedBox(height: 15),
                  _buildImageUploadSection(context, state),

                  const SizedBox(height: 40),

                  // زر إرسال الطلب
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF102C57),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () {
                        context.read<MaintenanceBloc>().add(SubmitTicket(
                          subject: state.selectedService,
                          description: state.descriptionText,
                        ));
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "إرسال الطلب",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- المكونات الفرعية (Widgets) ---

  Widget _buildStepHeader(String number, String title, {bool isRequired = false, bool isOptional = false}) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: const Color(0xFF102C57),
          child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        if (isRequired) const Text(" *", style: TextStyle(color: Colors.red)),
        if (isOptional) const Text(" (اختياري)", style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildServiceGrid(BuildContext context, MaintenanceState state) {
    final services = [
      {"name": "سباكة", "icon": Icons.water_drop_outlined, "color": Colors.blue},
      {"name": "تكييف", "icon": Icons.air, "color": Colors.cyan},
      {"name": "كهرباء", "icon": Icons.bolt, "color": Colors.orange},
      {"name": "مصاعد", "icon": Icons.unfold_more, "color": Colors.indigo},
      {"name": "نظافة", "icon": Icons.auto_awesome, "color": Colors.green},
      {"name": "أخرى", "icon": Icons.build_outlined, "color": Colors.grey},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 120,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        bool isSelected = state.selectedService == service['name'];
        return GestureDetector(
          onTap: () {
            context.read<MaintenanceBloc>().add(SelectService(service['name'] as String));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFFC5A353) : const Color(0xFFF1F5F9),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                if (isSelected)
                  const Positioned(
                    top: 8, right: 8,
                    child: CircleAvatar(radius: 4, backgroundColor: Color(0xFFC5A353)),
                  ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (service['color'] as Color).withOpacity(0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(service['icon'] as IconData, color: service['color'] as Color, size: 24),
                      ),
                      const SizedBox(height: 8),
                      Text(service['name'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDescriptionField(BuildContext context, MaintenanceState state) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          TextField(
            maxLines: 4,
            onChanged: (text) {
              context.read<MaintenanceBloc>().add(UpdateDescriptionText(text));
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "اشرح المشكلة بالتفصيل هنا...",
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${state.descriptionLength} / 500",
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(BuildContext context, MaintenanceState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildUploadBtn(Icons.camera_alt_outlined, "التقاط", () => _pickImage(context, ImageSource.camera)),
          const SizedBox(width: 10),
          _buildUploadBtn(Icons.image_outlined, "إضافة صورة", () => _pickImage(context, ImageSource.gallery)),
          const SizedBox(width: 10),

          // عرض الصور من الـ State
          ...state.selectedImages.asMap().entries.map((entry) {
            return _buildImagePreview(context, entry.key, entry.value);
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 50);
    if (pickedFile != null) {
      if (context.mounted) {
        context.read<MaintenanceBloc>().add(AddImage(File(pickedFile.path)));
      }
    }
  }

  Widget _buildImagePreview(BuildContext context, int index, File file) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 80, height: 80,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(file, width: 80, height: 80, fit: BoxFit.cover),
          ),
          Positioned(
            top: 5, left: 5,
            child: GestureDetector(
              onTap: () => context.read<MaintenanceBloc>().add(RemoveImage(index)),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.black.withOpacity(0.5),
                child: const Icon(Icons.close, color: Colors.white, size: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFC5A353), size: 24),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
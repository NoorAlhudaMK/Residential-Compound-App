import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_stepper/smart_stepper.dart';

import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../../Core/UIConstants/aivio_spacing.dart';
import '../../../../Data/Repositories/maintenance_repository.dart';
import '../BLoC/add_maintenance_bloc.dart';
import '../BLoC/add_maintenance_event.dart';
import '../BLoC/add_maintenance_state.dart';

class NewMaintenanceRequestView extends StatelessWidget {
  const NewMaintenanceRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddMaintenanceBloc(
        repository: MaintenanceRepository(),
      )..add(LoadInitialDataEvent()),
      child: const _NewMaintenanceRequestViewBody(),
    );
  }
}

class _NewMaintenanceRequestViewBody extends StatefulWidget {
  const _NewMaintenanceRequestViewBody();

  @override
  State<_NewMaintenanceRequestViewBody> createState() =>
      _NewMaintenanceRequestViewBodyState();
}

class _NewMaintenanceRequestViewBodyState
    extends State<_NewMaintenanceRequestViewBody> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (!context.mounted) return;
      context.read<AddMaintenanceBloc>().add(AddImage(File(pickedFile.path)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return BlocConsumer<AddMaintenanceBloc, AddMaintenanceState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("فشل إرسال الطلب: ${state.errorMessage}"),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم إرسال الطلب بنجاح"),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        // مزامنة حقل العنوان مع الـ State
        if (_titleController.text != state.titleText) {
          _titleController.text = state.titleText;
          _titleController.selection = TextSelection.fromPosition(
            TextPosition(offset: _titleController.text.length),
          );
        }

        // مزامنة حقل الوصف مع الـ State
        if (_descriptionController.text != state.descriptionText) {
          _descriptionController.text = state.descriptionText;
          _descriptionController.selection = TextSelection.fromPosition(
            TextPosition(offset: _descriptionController.text.length),
          );
        }

        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: colors.scaffoldBackground,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: colors.textMain,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  "طلب صيانة جديد",
                  style: TextStyle(
                    color: colors.textMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Container(
                    color: colors.scaffoldBackground,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SmartStepper(
                      currentStep: state.currentStep,
                      totalSteps: 3,
                      stepWidth: 40,
                      stepHeight: 40,
                      completeStepColor: colors.primary,
                      currentStepColor: colors.primary,
                      inactiveStepColor: colors.inputBorder,
                      onStepperTap: (index) {},
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.currentStep == 1) ...[
                            _buildStepHeader(
                              "1",
                              "فئة الصيانة (Category)",
                              colors,
                              isRequired: true,
                            ),
                            SizedBox(height: AppSpacing.md),
                            _buildCategoriesList(context, state, colors),
                          ] else if (state.currentStep == 2) ...[
                            _buildStepHeader(
                              "2",
                              "تفاصيل المشكلة والأولوية",
                              colors,
                              isRequired: true,
                            ),
                            SizedBox(height: AppSpacing.md),
                            _buildTitleField(context, colors), // حقل العنوان الجديد
                            SizedBox(height: AppSpacing.md),
                            _buildDescriptionField(context, colors),
                            SizedBox(height: AppSpacing.lg),
                            _buildPriorityDropdown(context, state, colors),
                          ] else if (state.currentStep == 3) ...[
                            _buildStepHeader(
                              "3",
                              "إرفاق صورة",
                              colors,
                              isOptional: true,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "موقع إرفاق الصورة (اختياري)",
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: AppFontSizes.bodyMedium,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildImagePickerSection(context, state, colors),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                padding: EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: AppSpacing.sm,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (state.currentStep > 1)
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.mdRadius,
                              ),
                            ),
                            onPressed: state.isLoading
                                ? null
                                : () => context
                                .read<AddMaintenanceBloc>()
                                .add(PreviousStepEvent()),
                            child: Text(
                              "السابق",
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: AppFontSizes.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (state.currentStep > 1) SizedBox(width: AppSpacing.sm),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.mdRadius,
                            ),
                          ),
                          onPressed: state.isLoading
                              ? null
                              : () {
                            if (state.currentStep == 1 &&
                                state.selectedCategoryId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "الرجاء اختيار فئة الصيانة أولاً للمتابعة",
                                  ),
                                  backgroundColor: colors.danger,
                                ),
                              );
                              return;
                            }

                            if (state.currentStep == 2) {
                              if (state.titleText.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "الرجاء كتابة عنوان المشكلة أولاً للمتابعة",
                                    ),
                                    backgroundColor: colors.danger,
                                  ),
                                );
                                return;
                              }
                              if (state.descriptionText.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "الرجاء كتابة وصف المشكلة أولاً للمتابعة",
                                    ),
                                    backgroundColor: colors.danger,
                                  ),
                                );
                                return;
                              }
                            }

                            if (state.currentStep < 3) {
                              context.read<AddMaintenanceBloc>().add(
                                NextStepEvent(),
                              );
                            } else {
                              context.read<AddMaintenanceBloc>().add(
                                SubmitTicket(
                                  subject: state.titleText,
                                  description: state.descriptionText,
                                ),
                              );
                            }
                          },
                          child: state.isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            state.currentStep == 3
                                ? "إرسال الطلب"
                                : "التالي",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepHeader(
      String number,
      String title,
      AppColors colors, {
        bool isRequired = false,
        bool isOptional = false,
      }) {
    return Row(
      children: [
        SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppFontSizes.bodyLarge,
            color: colors.textMain,
          ),
        ),
        if (isRequired) const Text(" *", style: TextStyle(color: Colors.red)),
        if (isOptional)
          Text(
            " (اختياري)",
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: AppFontSizes.caption,
            ),
          ),
      ],
    );
  }

  Widget _buildCategoriesList(
      BuildContext context,
      AddMaintenanceState state,
      AppColors colors,
      ) {
    if (state.isLoading && state.categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.categories.isEmpty) {
      return const Center(child: Text("لا توجد فئات صيانة متاحة حالياً"));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.categories.length,
      itemBuilder: (context, index) {
        final category = state.categories[index];
        final isSelected = state.selectedCategoryId == category.id;

        // استخراج الأيقونة واللون الخاص بالفئة
        final categoryIcon = _getIconData(category.icon);
        final categoryColor = _getCategoryColor(category.color, colors);

        return GestureDetector(
          onTap: () => context.read<AddMaintenanceBloc>().add(
            SelectCategory(category.id),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.lgRadius,
              border: Border.all(
                color: isSelected ? colors.primary : colors.inputBorder,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // عرض أيقونة الفئة بخلفية ملونة شفافة
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: AppFontSizes.bodyMedium,
                          fontWeight: FontWeight.bold,
                          color: colors.textMain,
                        ),
                      ),

                      // // يمكنك أيضاً إظهار اسم الفريق أو معلومات إضافية إن أردت
                      // const SizedBox(height: 4),
                      // Text(
                      //   "الفريق المسؤول: ${category.teamName}",
                      //   style: TextStyle(
                      //     fontSize: AppFontSizes.caption - 1,
                      //     color: colors.textSecondary,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: isSelected ? colors.primary : colors.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleField(BuildContext context, AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "عنوان المشكلة (Subject) *",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppFontSizes.bodyMedium,
            color: colors.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(color: colors.inputBorder),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: TextField(
            controller: _titleController,
            onChanged: (text) => context
                .read<AddMaintenanceBloc>()
                .add(UpdateTitleText(text)),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "أدخل عنواناً مختصراً للمشكلة...",
              hintStyle: TextStyle(
                color: colors.textSecondary,
                fontSize: AppFontSizes.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(BuildContext context, AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "تفاصيل المشكلة *",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppFontSizes.bodyMedium,
            color: colors.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(color: colors.inputBorder),
          ),
          padding: EdgeInsets.all(AppSpacing.md),
          child: TextField(
            maxLines: 4,
            controller: _descriptionController,
            onChanged: (text) => context
                .read<AddMaintenanceBloc>()
                .add(UpdateDescriptionText(text)),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "اشرح المشكلة بالتفصيل...",
              hintStyle: TextStyle(
                color: colors.textSecondary,
                fontSize: AppFontSizes.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown(
      BuildContext context,
      AddMaintenanceState state,
      AppColors colors,
      ) {
    if (state.priorities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "أولوية الطلب (Priority) *",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppFontSizes.bodyMedium,
            color: colors.textMain,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(color: colors.inputBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: state.selectedPriority,
              isExpanded: true,
              items: state.priorities.map((priority) {
                return DropdownMenuItem(
                  value: priority.id.toString(),
                  child: Text(priority.name),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  context.read<AddMaintenanceBloc>().add(SelectPriority(val));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerSection(
      BuildContext context,
      AddMaintenanceState state,
      AppColors colors,
      ) {
    return Column(
      children: [
        if (state.selectedImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.mdRadius,
                        image: DecorationImage(
                          image: FileImage(state.selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      left: 14,
                      child: GestureDetector(
                        onTap: () => context
                            .read<AddMaintenanceBloc>()
                            .add(RemoveImage(index)),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        const SizedBox(height: 15),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.mdRadius,
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () => _pickImage(context),
          icon: Icon(Icons.add_a_photo, color: colors.primary),
          label: Text(
            "إضافة صورة جديدة",
            style: TextStyle(color: colors.primary),
          ),
        ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName.toLowerCase().trim()) {
      case 'water_drop_outlined':
        return Icons.water_drop_outlined;
      case 'air':
        return Icons.air;
      case 'bolt':
        return Icons.bolt;
      case 'unfold_more':
        return Icons.unfold_more;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'build_outlined':
        return Icons.build_outlined;
      case 'plumbing':
        return Icons.plumbing;
      case 'carpenter':
        return Icons.carpenter;
      default:
        return Icons.build_rounded;
    }
  }

  Color _getCategoryColor(int colorCode, AppColors appColors) {
    switch (colorCode) {
      case 5:
        return Colors.purple;
      case 6:
        return Colors.teal;
      case 7:
        return Colors.orange;
      case 8:
        return Colors.indigo;
      case 9:
        return Colors.pink;
      case 10:
        return Colors.cyan;
      case 11:
        return Colors.amber.shade700;
      case 12:
        return Colors.deepOrange;
      case 1:
        return appColors.primary;
      case 2:
        return Colors.blue;
      default:
        return appColors.primary;
    }
  }
}
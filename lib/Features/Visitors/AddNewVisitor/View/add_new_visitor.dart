import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:smart_stepper/smart_stepper.dart';

import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../../Core/UIConstants/aivio_spacing.dart';
import '../../../../Data/Repositories/visitor_repository.dart';
import '../../VisitorPermitView/visitor_permit_view.dart';
import '../BLoC/add_visitors_bloc.dart';
import '../BLoC/add_visitors_event.dart';
import '../BLoC/add_visitors_state.dart';

class AddNewVisitorView extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController companionsController = TextEditingController();
  final TextEditingController carPlateController = TextEditingController();

  // متغير لتخزين رقم الهاتف بصيغته الصحيحة بدون تكرار رمز الدولة
  String fullPhoneNumber = '';

  AddNewVisitorView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocProvider(
      create: (context) => AddVisitorBloc(repository: VisitorRepository()),
      child: BlocConsumer<AddVisitorBloc, AddVisitorState>(
        listener: (context, state) {
          if (state.lastCreatedVisitor != null && !state.isGenerating) {
            final createdVisitor = state.lastCreatedVisitor!;

            nameController.clear();
            phoneController.clear();
            nationalIdController.clear();
            reasonController.clear();
            companionsController.clear();
            carPlateController.clear();
            fullPhoneNumber = '';

            FocusScope.of(context).unfocus();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VisitorPermitView(
                  visitorName: createdVisitor.visitorName,
                  qrToken: createdVisitor.qrToken,
                ),
              ),
            );
          }

          if (state.errorMessage != null && !state.isGenerating) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("خطأ: ${state.errorMessage}"),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: const Color(0xFFF9FAFB),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    "الأمن والزوار",
                    style: TextStyle(
                      color: colors.textMain,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSizes.headingSmall,
                    ),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: AppIconSizes.md,
                      color: colors.textMain,
                    ),
                  ),
                ),
                body: Column(
                  children: [
                    Container(
                      color: const Color(0xFFF9FAFB),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        child: Column(
                          children: [
                            if (state.currentStep == 1) ...[
                              _buildBasicInfoStep(context, state, colors),
                            ] else if (state.currentStep == 2) ...[
                              _buildTimeAndReasonStep(context, state, colors),
                            ] else if (state.currentStep == 3) ...[
                              _buildCompanionAndCarStep(context, state, colors),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: Container(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  decoration: const BoxDecoration(
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
                              onPressed: state.isGenerating
                                  ? null
                                  : () => context
                                  .read<AddVisitorBloc>()
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
                        flex: state.currentStep > 1 ? 2 : 1,
                        child: SizedBox(
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.mdRadius,
                              ),
                            ),
                            onPressed: state.isGenerating
                                ? null
                                : () {
                              if (state.currentStep == 1) {
                                if (nameController.text.trim().isEmpty ||
                                    fullPhoneNumber.trim().isEmpty ||
                                    nationalIdController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("الرجاء ملء الحقول الأساسية أولاً"),
                                      backgroundColor: colors.danger,
                                    ),
                                  );
                                  return;
                                }
                              }

                              if (state.currentStep == 2) {
                                if (reasonController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("الرجاء كتابة سبب الزيارة أولاً"),
                                      backgroundColor: colors.danger,
                                    ),
                                  );
                                  return;
                                }
                              }

                              if (state.currentStep < 3) {
                                context.read<AddVisitorBloc>().add(NextStepEvent());
                              } else {
                                final dateFormat = intl.DateFormat('yyyy-MM-dd HH:mm:ss');
                                DateTime startDateTime;
                                DateTime endDateTime;

                                if (state.isTimeSelected) {
                                  startDateTime = state.selectedDate;
                                } else {
                                  startDateTime = DateTime(
                                    state.selectedDate.year,
                                    state.selectedDate.month,
                                    state.selectedDate.day,
                                    0, 0, 0,
                                  );
                                }

                                endDateTime = DateTime(
                                  state.selectedDate.year,
                                  state.selectedDate.month,
                                  state.selectedDate.day,
                                  23, 59, 59,
                                );

                                context.read<AddVisitorBloc>().add(
                                  CreateVisitor(
                                    name: nameController.text,
                                    phone: fullPhoneNumber, // نرسل الرقم الكامل المخزن
                                    unitId: 1,
                                    validFrom: dateFormat.format(startDateTime),
                                    validTo: dateFormat.format(endDateTime),
                                    hasCar: state.hasCar,
                                    carPlate: state.hasCar ? carPlateController.text : "",
                                  ),
                                );
                              }
                            },
                            child: state.isGenerating
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : Text(
                              state.currentStep == 3 ? "توليد كود الدخول" : "التالي",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSizes.bodyMedium,
                                fontWeight: FontWeight.bold,
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
      ),
    );
  }

  Widget _buildBasicInfoStep(BuildContext context, AddVisitorState state, AppColors colors) {
    return _buildSectionCard(
      title: "بيانات الهوية",
      icon: Icons.person_outline,
      colors: colors,
      children: [
        _label("اسم الزائر الثلاثي *"),
        TextField(
          controller: nameController,
          decoration: _inputDecoration("مثال: علي حسن محمد", colors, Icons.person),
        ),
        SizedBox(height: AppSpacing.md),
        _label("رقم الهاتف *"),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: colors.inputFill,
              borderRadius: AppRadius.mdRadius,
              border: Border.all(color: colors.inputBorder),
            ),
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                fullPhoneNumber = number.phoneNumber?.replaceAll('+', '') ?? '';
              },
              selectorConfig: const SelectorConfig(
                selectorType: PhoneInputSelectorType.DROPDOWN,
                showFlags: true,
                useEmoji: true,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(
                color: colors.textMain,
                fontSize: AppFontSizes.bodyMedium,
              ),
              initialValue: PhoneNumber(isoCode: 'IQ'),
              maxLength: 12,
              formatInput: true,
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
              inputDecoration: InputDecoration(
                hintText: "771 6607 653",
                hintStyle: TextStyle(color: colors.textSecondary, fontSize: AppFontSizes.bodySmall),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
              ),
              textStyle: TextStyle(
                fontSize: AppFontSizes.bodyMedium,
                color: colors.textMain,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        _label("رقم البطاقة الوطنية *"),
        TextField(
          controller: nationalIdController,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration("مثال: 20002335545", colors, Icons.badge_outlined),
          maxLength: 12,
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildTimeAndReasonStep(BuildContext context, AddVisitorState state, AppColors colors) {
    return _buildSectionCard(
      title: "تفاصيل الزيارة",
      icon: Icons.event_note_outlined,
      colors: colors,
      children: [
        _label("سبب الزيارة *"),
        TextField(
          controller: reasonController,
          decoration: _inputDecoration("مثال: زيارة عائلية", colors, Icons.info_outline),
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("التاريخ"),
                  SizedBox(width: double.infinity, child: _buildDatePicker(context, state)),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("الوقت (اختياري)"),
                  SizedBox(width: double.infinity, child: _buildTimePicker(context, state)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompanionAndCarStep(BuildContext context, AddVisitorState state, AppColors colors) {
    return Column(
      children: [
        _buildSectionCard(
          title: "المرافقين والسيارة",
          icon: Icons.group_outlined,
          colors: colors,
          children: [
            _label("عدد المرافقين"),
            TextField(
              controller: companionsController,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("مثال: 2", colors, Icons.people_outline),
            ),
            SizedBox(height: AppSpacing.md),
            Material(
              color: Colors.transparent,
              child: CheckboxListTile(
                title: Text(
                  "الزائر يمتلك سيارة",
                  style: TextStyle(fontSize: AppFontSizes.bodyMedium, fontWeight: FontWeight.w600),
                ),
                value: state.hasCar,
                onChanged: (val) => context.read<AddVisitorBloc>().add(UpdateHasCar(val!)),
                contentPadding: EdgeInsets.zero,
                activeColor: colors.primary,
              ),
            ),
            if (state.hasCar) ...[
              SizedBox(height: AppSpacing.sm),
              _label("رقم لوحة السيارة"),
              TextField(
                controller: carPlateController,
                decoration: _inputDecoration("مثال: 12345 بغداد", colors, Icons.numbers),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required AppColors colors,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colors.primary, size: AppIconSizes.md),
            SizedBox(width: AppSpacing.xs),
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.bodyLarge,
                fontWeight: FontWeight.w700,
                color: colors.textMain,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        ...children,
      ],
    );
  }

  Widget _label(String text) => Padding(
    padding: EdgeInsets.only(bottom: AppSpacing.md),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: AppFontSizes.bodyMedium,
      ),
    ),
  );

  InputDecoration _inputDecoration(String hint, AppColors colors, IconData icon) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: colors.textSecondary, fontSize: AppFontSizes.bodySmall),
        suffixIcon: Icon(icon, color: colors.textSecondary, size: AppIconSizes.sm),
        filled: true,
        fillColor: colors.inputFill,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdRadius,
          borderSide: BorderSide(color: colors.primary),
        ),
      );

  Widget _buildDatePicker(BuildContext context, AddVisitorState state) {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: state.selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2027),
        );
        if (picked != null) {
          final DateTime newDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            state.selectedDate.hour,
            state.selectedDate.minute,
          );
          if (context.mounted) {
            context.read<AddVisitorBloc>().add(UpdateDate(newDateTime));
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.mdRadius,
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          intl.DateFormat('yyyy/MM/dd').format(state.selectedDate),
          style: TextStyle(fontSize: AppFontSizes.bodyMedium),
        ),
      ),
    );
  }

  Widget _buildTimePicker(BuildContext context, AddVisitorState state) {
    return InkWell(
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(state.selectedDate),
        );
        if (picked != null) {
          final DateTime newDateTime = DateTime(
            state.selectedDate.year,
            state.selectedDate.month,
            state.selectedDate.day,
            picked.hour,
            picked.minute,
          );
          if (context.mounted) {
            context.read<AddVisitorBloc>().add(UpdateDate(newDateTime));
            context.read<AddVisitorBloc>().add(UpdateIsTimeSelected(true));
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.mdRadius,
            border: Border.all(color: const Color(0xFFE5E7EB),
        ),
        ),
        child: Text(
          intl.DateFormat('hh:mm a', 'ar').format(state.selectedDate),
          style: TextStyle(fontSize: AppFontSizes.bodyMedium),
        ),
      ),
    );
  }
}
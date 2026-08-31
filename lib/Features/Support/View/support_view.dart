import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../BLoC/support_bloc.dart';
import '../BLoC/support_event.dart';
import '../BLoC/support_state.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';

class SupportCenterScreen extends StatelessWidget {
  const SupportCenterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SupportBloc(),
      child: const SupportViewContent(),
    );
  }
}

class SupportViewContent extends StatelessWidget {
  const SupportViewContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();
    const String phoneNumber = "+9647716607653";

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is SupportCallError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: appColors.danger),
            );
          }
        },
        child: Scaffold(
          backgroundColor: appColors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'مركز الدعم',
              style: TextStyle(
                color: appColors.textAppBar,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: AppSpacing.allSm,
                decoration: BoxDecoration(
                  color: appColors.inputFill,
                  borderRadius: AppRadius.mdRadius,
                  border: Border.all(color: appColors.inputBorder),
                ),
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: appColors.textMain,
                  size: AppIconSizes.md,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            automaticallyImplyActions: false,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: AppSpacing.allMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.wechat_outlined,
                        size: AppIconSizes.xl,
                        color: appColors.textAppBar.withOpacity(0.7),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        "AIVIO CARE",
                        style: TextStyle(
                          color: appColors.textAppBar,
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        "مركز الدعم",
                        style: TextStyle(
                          color: appColors.textMain,
                          fontSize: AppFontSizes.displayMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        "اختر القناة وسيقوم فريق استقبال السكان بتوجيهك",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: appColors.textSecondary,
                          fontSize: AppFontSizes.bodyMedium,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xxl),

                  // زر مراسلة مكتب السكان
                  _buildSupportChannelCard(
                    appColors: appColors,
                    icon: Icons.message_outlined,
                    title: "مراسلة مكتب السكان",
                    subtitle: "عادة ما يتم الرد خلال 15 دقيقة",
                    onTap: () {},
                  ),
                  SizedBox(height: AppSpacing.md),

                  // زر الاتصال بمكتب الحي (مربوط بالـ BLoC)
                  BlocBuilder<SupportBloc, SupportState>(
                    builder: (context, state) {
                      return _buildSupportChannelCard(
                        appColors: appColors,
                        icon: state is SupportCallLoading
                            ? Icons.hourglass_empty
                            : Icons.phone_outlined,
                        title: "الاتصال بمكتب الحي",
                        subtitle: "+964 771 660 7653",
                        subtitleIsPhoneNumber: true,
                        onTap: () {
                          BlocProvider.of<SupportBloc>(context)
                              .add(CallCommunityOfficeEvent(phoneNumber));
                        },
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.md),

                  // زر فتح طلب دعم
                  _buildSupportChannelCard(
                    appColors: appColors,
                    icon: Icons.assignment_outlined,
                    title: "فتح طلب دعم",
                    subtitle: "للاستفسارات غير العاجلة",
                    onTap: () {},
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // بطاقة ساعات العمل
                  Container(
                    padding: AppSpacing.allMd,
                    decoration: BoxDecoration(
                      color: appColors.statusApprovedBg,
                      borderRadius: AppRadius.mdRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: AppIconSizes.sm,
                          color: appColors.statusApprovedText,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          "مكتب السكان: يومياً، 08:00–22:00",
                          style: TextStyle(
                            color: appColors.statusApprovedText,
                            fontSize: AppFontSizes.bodyMedium,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportChannelCard({
    required AppColors appColors,
    required IconData icon,
    required String title,
    required String subtitle,
    bool subtitleIsPhoneNumber = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.allMd,
        decoration: BoxDecoration(
          color: appColors.inputFill,
          borderRadius: AppRadius.xlRadius,
          border: Border.all(color: appColors.inputBorder, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: AppIconSizes.md,
              color: appColors.primary,
            ),
            SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: appColors.textMain,
                      fontSize: AppFontSizes.bodyMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: subtitleIsPhoneNumber ? appColors.textMain : appColors.textSecondary,
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: subtitleIsPhoneNumber ? FontWeight.w600 : FontWeight.normal,
                        letterSpacing: subtitleIsPhoneNumber ? 1.0 : 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: AppIconSizes.sm,
              color: appColors.textMain,
            ),
          ],
        ),
      ),
    );
  }
}
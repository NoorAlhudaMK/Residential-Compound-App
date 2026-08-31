import 'package:flutter/material.dart';
import 'package:residential_compound_app/Core/Colors/app_colors.dart';
import 'package:residential_compound_app/Core/UIConstants/aivio_spacing.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppColors colors = AppColors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'تتبع الطلب',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.textMain,
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.inputBorder.withOpacity(0.5)),
                ),
                child: Icon(Icons.arrow_back_outlined, color: colors.textMain, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // أيقونة النجاح الكبيرة
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  'AIVIO MARKET',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colors.textSecondary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'تم تأكيد الطلب',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.textMain,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'التوصيل خلال 35-45 دقيقة • AM-5834# طلب',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),

                // خطوات تتبع الطلب (Timeline) - متقاربة وبمسافات محددة
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      _buildTimelineStep(
                        title: 'تم استلام الطلب',
                        stepNumber: '',
                        isCompleted: true,
                        isCurrent: false,
                        hasLine: true,
                        colors: colors,
                      ),
                      _buildTimelineStep(
                        title: 'يقوم سوق AIVIO بتجهيز طلبك',
                        stepNumber: '2',
                        isCompleted: false,
                        isCurrent: true,
                        hasLine: true,
                        colors: colors,
                      ),
                      _buildTimelineStep(
                        title: 'تم تعيين مندوب التوصيل',
                        stepNumber: '3',
                        isCompleted: false,
                        isCurrent: false,
                        hasLine: true,
                        colors: colors,
                      ),
                      _buildTimelineStep(
                        title: 'تم التوصيل إلى باب منزلك',
                        stepNumber: '4',
                        isCompleted: false,
                        isCurrent: false,
                        hasLine: false,
                        colors: colors,
                      ),
                    ],
                  ),
                ),

SizedBox(height: AppSpacing.xxl,),
                // زر تسوق المتجر
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.primary, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    child: Text(
                      'تسوق المتجر',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
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
  }

  Widget _buildTimelineStep({
    required String title,
    required String stepNumber,
    required bool isCompleted,
    required bool isCurrent,
    required bool hasLine,
    required AppColors colors,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 30,
          child: Column(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: (isCompleted || isCurrent) ? colors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (isCompleted || isCurrent) ? colors.primary : colors.inputBorder,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : Text(
                    stepNumber,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCurrent ? Colors.white : colors.textSecondary,
                    ),
                  ),
                ),
              ),
              if (hasLine)
                Container(
                  width: 2,
                  height: 32, // التحكم بطول الخط الرابط بين الخطوات لتصغير المسافة
                  color: colors.inputBorder,
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: (isCompleted || isCurrent) ? FontWeight.bold : FontWeight.w500,
                  color: (isCompleted || isCurrent) ? colors.textMain : colors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
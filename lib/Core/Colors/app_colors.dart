import 'package:flutter/material.dart';

class AppColors {
  static bool isDark = false;

  // خلفية التطبيق العامة
  Color get scaffoldBackground => isDark
      ? const Color(0xFF111E1A) // أخضر داكن عميق للوضع الليلي
      : const Color(0xFFF7F5F0); // خلفية بيج/فاتحة دافئة للوضع النهاري

  // اللون الأساسي للتطبيق (الأخضر الداكن الخاص بالهوية)
  Color get primary => const Color(0xFF134E4A);

  // التدرج اللون الأساسي (مستخدم في البطاقات أو الأزرار البارزة مثل Outstanding balance)
  LinearGradient get primaryGradient => isDark
      ? LinearGradient(
          colors: [Color(0xFF45A28E), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : LinearGradient(
          colors: [Color(0xFF2DD4BF), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  // لون النصوص الرئيسية
  Color get textMain =>
      isDark ? const Color(0xFFF3F4F6) : const Color(0xFF0F172A);

  // لون النصوص في الآب بار
  Color get textAppBar =>
      isDark ? const Color(0xFFF3F4F6) : const Color(0xFF134E4A);

  // لون النصوص الثانوية
  Color get textSecondary =>
      isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);

  // خلفية حقول الإدخال والعناصر المرتفعة (Cards)
  Color get inputFill => isDark ? const Color(0xFF1A2E28) : Colors.white;

  Color get tabFill => isDark ? const Color(0xFFE2E8F0) : Colors.white;

  Color get paymentIcon => isDark ? const Color(0xFF9CA3AF) : const Color(0xFF134E4A);

  Color get bottomBarIcon => isDark ? Colors.white : const Color(0xFF134E4A);

  // لون الحدود
  Color get inputBorder =>
      isDark ? const Color(0xFF264238) : const Color(0xFFE2E8F0);

  // خلفية الأزرار الثانوية
  Color get secondaryBtnBg =>
      isDark ? const Color(0xFF1A2E28) : const Color(0xFFEDF2F0);

  // حالة الموافقة (Approved)
  Color get statusApprovedBg =>
      isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
  Color get statusApprovedText =>
      isDark ? const Color(0xFF6EE7B7) : const Color(0xFF166534);

  // حالة الوصول أو قيد التنفيذ (Arrived / Pending)
  Color get statusArrivedBg =>
      isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE);
  Color get statusArrivedText =>
      isDark ? const Color(0xFF93C5FD) : const Color(0xFF1E40AF);

  // الحالة الافتراضية
  Color get statusDefaultBg =>
      isDark ? const Color(0xFF1F2937) : const Color(0xFFF1F5F9);
  Color get statusDefaultText =>
      isDark ? const Color(0xFFD1D5DB) : const Color(0xFF475569);

  // لون التنبيهات أو الحالات الخطرة (Danger / Emergency)
  Color get danger => const Color(0xFFC05A53);
}

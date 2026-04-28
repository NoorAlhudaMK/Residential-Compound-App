import 'package:flutter/material.dart';

class AppColors {
  static bool isDark = false;

  Color get scaffoldBackground => isDark
      ? const Color(0xFF0D1117)
      : const Color(0xFFF8FAFC);

  // خلفية البطاقة (Card) في صفحة LoginView
  Color get cardBackground => isDark
      ? const Color(0xFF0F172A)
      : Colors.white;

  Color get primary => isDark
      ? const Color(0xFFEA8E1B)
      : const Color(0xFF1D4ED8);

  Color get textMain => isDark
      ? Colors.white
      : const Color(0xFF0F172A);

  Color get textSecondary => isDark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF64748B);

  Color get inputFill => isDark
      ? Colors.black.withOpacity(0.2)
      : const Color(0xFFF1F5F9);

  Color get inputBorder => isDark
      ? const Color(0xFF1E293B)
      : const Color(0xFFE2E8F0);

  Color get iconColor => isDark
      ? const Color(0xFF94A3B8)
      : const Color(0xFF94A3B8);

  // ألوان الأيقونات والخلفيات الصغيرة
  Color get iconBlue => const Color(0xFFE0E7FF);
  Color get iconRed => const Color(0xFFFEE2E2);
  Color get iconGreen => const Color(0xFFDCFCE7);

  Color get accentRed => const Color(0xFFEF4444);

  // ألوان الحالات (Status Colors) - مضافة لصفحة الزوار والداشبورد
  Color get accentGreen => const Color(0xFF55E6C1);  // للدخول أو النجاح
  Color get accentBlue => const Color(0xFF74b9ff);   // للتنبيهات أو الروابط

  // ألوان إضافية للـ Avatar والبطاقات (كما في الصورة)
  Color get visitorAvatarBlue => const Color(0xFF0984e3);
  Color get visitorAvatarIndigo => const Color(0xFF6c5ce7);
  Color get visitorAvatarTeal => const Color(0xFF00cec9);

  // لون الحدود (Borders)
  Color get borderColor => isDark ? Colors.white10 : Colors.black.withOpacity(0.05);

  // أضف هذه لـ AppColors
  Color get apartmentIconBg => const Color(0xFFE6FFFA);
  Color get carIconBg => const Color(0xFFFFF7ED);
  Color get phoneIconBg => const Color(0xFFEEF2FF);

  Color get apartmentIconColor => const Color(0xFF38B2AC);
  Color get carIconColor => const Color(0xFFF6AD55);
  Color get phoneIconColor => const Color(0xFF6366F1);
}
import 'package:flutter/material.dart';

class AppColors {
  static bool isDark = false;

  Color get scaffoldBackground => isDark
      ? const Color(0xFF0D1117)
      : const Color(0xFFFFFFFF);

  Color get primary => const Color(0xFF102C57);

  Color get goldAccent => const Color(0xFFDAC077);

  Color get textMain => isDark
      ? Colors.white
      : const Color(0xFF102C57);

  Color get textSecondary => const Color(0xFF94A3B8);

  Color get inputFill => const Color(0xFFF8FAFC);

  Color get inputBorder => const Color(0xFFE2E8F0);

  Color get secondaryBtnBg => const Color(0xFFF8FAFC);

  static const Color statusApprovedBg = Color(0xFFDCFCE7); // أخضر فاتح
  static const Color statusApprovedText = Color(0xFF166534); // أخضر داكن

  static const Color statusArrivedBg = Color(0xFFDBEAFE); // أزرق فاتح
  static const Color statusArrivedText = Color(0xFF1E40AF); // أزرق داكن

  static const Color statusDefaultBg = Color(0xFFF1F5F9); // رمادي فاتح
  static const Color statusDefaultText = Color(0xFF475569); // رمادي
}
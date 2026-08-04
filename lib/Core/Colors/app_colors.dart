import 'package:flutter/material.dart';

class AppColors {
  static bool isDark = false;

  Color get scaffoldBackground => isDark
      ? const Color(0xFF0D1117)
      : const Color(0xFFF7F7FD);

  Color get primary => const Color(0xFF7C5CFC);

  LinearGradient get primaryGradient => const LinearGradient(
    colors: [Color(0xFF58D1D1), Color(0xFF7C5CFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  Color get textMain => isDark
      ? Colors.white
      : const Color(0xFF1E1E2D);

  Color get textSecondary => const Color(0xFF71717A);

  Color get inputFill => isDark ? const Color(0xFF1E1E2D) : Colors.white;

  Color get inputBorder => const Color(0xFFE4E4E7);

  Color get secondaryBtnBg => const Color(0xFFF1F1F9);

  Color get statusApprovedBg => const  Color(0xFFDCFCE7);
  Color get statusApprovedText => const  Color(0xFF166534);

  Color get statusArrivedBg => const  Color(0xFFDBEAFE);
  Color get statusArrivedText => const  Color(0xFF1E40AF);

  Color get statusDefaultBg => const  Color(0xFFF1F5F9);
  Color get statusDefaultText => const  Color(0xFF475569);

  Color get danger => const  Color(0xFFE11D48);
}
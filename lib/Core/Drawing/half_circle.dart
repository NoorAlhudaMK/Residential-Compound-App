import 'package:flutter/material.dart';

class HalfCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFE5D4C0) // لون القوس (يمكنك تغييره حسب رغبتك)
      ..style = PaintingStyle.fill;

    // استخدام مسار (Path) لرسم الشكل المقوس بشكل متناسق مع الأبعاد
    final Path path = Path();

    // نقطة البداية من أسفل اليسار
    path.moveTo(0, size.height);

    // رسم القوس العلوي
    path.arcToPoint(
      Offset(size.width, size.height),
      radius: Radius.circular(size.width / 2),
      largeArc: true,
      clockwise: true,
    );

    // إغلاق المسار لملء الشكل بالكامل
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
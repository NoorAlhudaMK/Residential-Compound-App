import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../Auth/View/login_view.dart';

class ResidentIntroScreen extends StatelessWidget {
  const ResidentIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF6C63FF);

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: IntroductionScreen(
          globalBackgroundColor: Colors.white,
          allowImplicitScrolling: true,
          pages: [
            PageViewModel(
              title: "تطبيق السكان (AIVIO)",
              body: "كل ما يحتاجه الساكن في قناة واحدة؛ تجربة يومية تختصر الوصول إلى الخدمات، الفواتير، الصيانة، الدخول، والحجوزات داخل المجمع.",
              image: Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.home_rounded,
                    size: 70,
                    color: primaryColor,
                  ),
                ),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                bodyTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
                imagePadding: EdgeInsets.all(24),
              ),
            ),

            PageViewModel(
              title: "الصيانة والفواتير بين يديك",
              bodyWidget: Column(
                children: const [
                  Text(
                    "• طلبات الصيانة: إنشاء الطلب وإرفاق الصور ومتابعة الحالة لحظياً.",
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• دفع الفواتير: عرض الفواتير، سجل المدفوعات، والدفع الإلكتروني بكل ميسور.",
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
              image: const Center(
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 80,
                  color: primaryColor,
                ),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                imagePadding: EdgeInsets.all(24),
              ),
            ),

            PageViewModel(
              title: "فتح البوابات والدخول الذكي",
              body: "إمكانية الدخول عبر رمز الاستجابة السريعة (QR) أو تقنية (NFC) وفق الصلاحيات المعتمدة للساكن بكل أمان وسهولة.",
              image: const Center(
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: 80,
                  color: primaryColor,
                ),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                bodyTextStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
                imagePadding: EdgeInsets.all(24),
              ),
            ),

            PageViewModel(
              title: "مرافق، تنبيهات، وتواصل مباشر",
              bodyWidget: Column(
                children: const [
                  Text(
                    "• حجز المرافق: حجز القاعات، الملاعب، والنادي والمرافق المشتركة.",
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "• التنبيهات الفورية والشكاوى: إشعارات الفواتير والصيانة والأمن، وقناة تواصل مباشرة مع الإدارة.",
                    style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                ],
              ),
              image: const Center(
                child: Icon(
                  Icons.notifications_active_rounded,
                  size: 80,
                  color: primaryColor,
                ),
              ),
              decoration: const PageDecoration(
                pageColor: Colors.white,
                titleTextStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
                imagePadding: EdgeInsets.all(24),
              ),
            ),
          ],
          showSkipButton: true,
          showNextButton: true,
          skip: const Text(
            "تخطي",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          next: const Icon(Icons.arrow_forward_ios, color: primaryColor, size: 18),
          done: const Text(
            "ابدأ الان",
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          onDone: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          onSkip: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          },
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(22.0, 10.0),
            activeColor: primaryColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 4.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      ),
    );
  }
}
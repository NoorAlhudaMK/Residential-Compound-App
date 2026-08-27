import 'package:flutter/material.dart';
import 'package:residential_compound_app/Core/Colors/app_colors.dart';

import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';

class AboutAppPage extends StatelessWidget {
  AboutAppPage({super.key});

  AppColors colors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colors.scaffoldBackground,
          elevation: 0,
          scrolledUnderElevation: 0.0,
          title: Text(
            "عــن الــتــطــبــيــق",
            style: TextStyle(
              color: colors.textMain,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.headingSmall,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, size: AppIconSizes.md,
              color: colors.textMain, ),
          ),
        ),
        backgroundColor: AppColors().scaffoldBackground,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.apartment_rounded,
                        size: 50,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'أيفيو - السكان (AIVIO)',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'نظام إدارة المجمعات السكنية الذكي',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // نبذة تعريفيّة
              _buildSectionCard(
                title: 'نبذة تعريفيّة',
                content:
                'تطبيق أيفيو (AIVIO) هو منصة رقمية ذكية ومتكاملة مصممة خصيصاً لإدارة المجمعات السكنية. يهدف النظام إلى إعادة صياغة تجربة إدارة المجمع من خلال ربط السكان، الإدارة، الأمن، الصيانة، والجهات الخدمية في تجربة رقمية واحدة وموحدة.',
                icon: Icons.info_outline,
              ),
              const SizedBox(height: 16),

              // الرؤية والأهداف
              _buildSectionCard(
                title: 'رؤيتنا',
                content:
                'إدارة أذكى، مجمع أكثر أمانًا، وتجربة أفضل. نسعى لتحويل التحديات التشغيلية اليومية إلى فرص حقيقية للكفاءة والنمو، عبر أتمتة العمليات وتقديم حلول تقنية مرنة.',
                icon: Icons.visibility_outlined,
              ),
              const SizedBox(height: 16),

              // أبرز المميزات
              const Text(
                'أبرز مميزات التطبيق',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem(
                title: 'إدارة الفواتير والمدفوعات',
                description:
                'عرض الفواتير وسجل المدفوعات مع دعم الدفع الإلكتروني.',
                icon: Icons.payment,
              ),
              _buildFeatureItem(
                title: 'طلبات الصيانة اللحظية',
                description:
                'إنشاء طلبات الصيانة وإرفاق الصور ومتابعة حالتها حتى الإنجاز.',
                icon: Icons.build_outlined,
              ),
              _buildFeatureItem(
                title: 'فتح البوابات والتحكم بالدخول',
                description:
                'دخول ذكي عبر رمز الاستجابة السريعة (QR) أو NFC وفق الصلاحيات.',
                icon: Icons.qr_code_scanner,
              ),
              _buildFeatureItem(
                title: 'حجز المرافق المشتركة',
                description:
                'حجز القاعات، الملاعب، النادي والمرافق الترفيهية بسهولة.',
                icon: Icons.event_available,
              ),
              _buildFeatureItem(
                title: 'التنبيهات الفورية والشكاوى',
                description:
                'إشعارات ذكية وقناة تواصل مباشرة مع الإدارة والأمن.',
                icon: Icons.notifications_active_outlined,
              ),

              const SizedBox(height: 24),
              // الإصدار
              const Center(
                child: Text(
                  'الإصدار 1.0.0 • 2026',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF6C63FF), size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
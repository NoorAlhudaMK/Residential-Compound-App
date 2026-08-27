import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as https;
import 'package:residential_compound_app/Data/Models/announcement_model.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';

class AnnouncementDetailsView extends StatelessWidget {
  final AnnouncementModel announcement;

  const AnnouncementDetailsView({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: colors.scaffoldBackground,
          elevation: 0,
          scrolledUnderElevation: 0.0,
          title: Text(
            "تفاصيل الإعلان",
            style: TextStyle(
              fontSize: AppFontSizes.headingSmall,
              fontWeight: FontWeight.bold,
              color: colors.textMain,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: colors.textMain),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض الصورة إذا كانت متوفرة
              if (announcement.imageUrl.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: AppRadius.lgRadius,
                  child: SizedBox(
                    width: double.infinity,
                    height: 220, // ارتفاع مناسب لصورة الإعلان
                    child: _buildImageWithToken(announcement.imageUrl),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
              ],

              // عنوان الإعلان
              Text(
                announcement.title,
                style: TextStyle(
                  fontSize: AppFontSizes.headingSmall,
                  fontWeight: FontWeight.bold,
                  color: colors.textMain,
                ),
              ),
              SizedBox(height: AppSpacing.md),

              // تفاصيل/نص الإعلان
              Text(
                announcement.subtitle,
                style: TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  color: colors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithToken(String imageUrl) {
    return FutureBuilder<String?>(
      future: CacheManager.getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return FutureBuilder<https.Response>(
          future: https.get(
            Uri.parse(imageUrl),
            headers: {'Authorization': 'Bearer ${snapshot.data}'},
          ),
          builder: (context, resp) {
            if (resp.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (resp.hasData && resp.data!.statusCode == 200) {
              return Image.memory(
                resp.data!.bodyBytes,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            }
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }
}


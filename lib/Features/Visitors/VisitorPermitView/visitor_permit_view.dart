import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:residential_compound_app/Features/Visitors/AddNewVisitor/View/add_new_visitor.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../Core/Colors/app_colors.dart';
import '../../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../../Core/UIConstants/aivio_spacing.dart';

class VisitorPermitView extends StatelessWidget {
  final String visitorName;
  final String qrToken;
  final ScreenshotController screenshotController = ScreenshotController();

  VisitorPermitView({super.key, required this.visitorName, required this.qrToken});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "تصريح الدخول",
            style: TextStyle(
              color: colors.textMain,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSizes.headingSmall,
            ),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(
              context
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: AppIconSizes.md,
              color: colors.textMain,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.xlRadius,
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  visitorName,
                  style: TextStyle(
                    fontSize: AppFontSizes.headingMedium,
                    fontWeight: FontWeight.bold,
                    color: colors.textMain,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Screenshot(
                  controller: screenshotController,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        QrImageView(data: qrToken, size: 220.0),
                        const SizedBox(height: 12),
                        const Text(
                          " تصريح دخول مجمع AIVIO",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => _shareQrCode(context),
                    icon: Icon(Icons.share, size: AppIconSizes.md),
                    label: Text(
                      "مشاركة التصريح",
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mdRadius,
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

  Future<void> _shareQrCode(BuildContext context) async {
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/qr_permit_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(imagePath);
        await file.writeAsBytes(image);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'إليك تصريح دخول الزائر: $visitorName',
        );
      }
    } catch (e) {
      debugPrint("Sharing Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تعذر المشاركة: $e")),
        );
      }
    }
  }
}
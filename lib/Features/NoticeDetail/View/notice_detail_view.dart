import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Core/Colors/app_colors.dart';

import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../BLoC/notice_detail_bloc.dart';
import '../BLoC/notice_detail_state.dart';

class NoticeDetailScreen extends StatelessWidget {
  const NoticeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppColors colors = AppColors();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: BlocProvider(
          create: (context) => NoticeDetailBloc(),
          child: Scaffold(
            backgroundColor: colors.scaffoldBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'إشعار المجمع',
                style: TextStyle(
                  color: colors.textAppBar,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              leading: IconButton(
                icon: Container(
                  padding: AppSpacing.allSm,
                  decoration: BoxDecoration(
                    color: colors.inputFill,
                    borderRadius: AppRadius.mdRadius,
                    border: Border.all(color: colors.inputBorder),
                  ),
                  child: Icon(
                    Icons.arrow_back_outlined,
                    color: colors.textMain,
                    size: AppIconSizes.md,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              automaticallyImplyActions: false,
              automaticallyImplyLeading: false,
            ),
            body: BlocBuilder<NoticeDetailBloc, NoticeDetailState>(
              builder: (context, state) {
                if (state is NoticeDetailLoaded) {
                  final notice = state.notice;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Image Card with Overlay
                        Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/notice_details_image.png'), // أو NetworkImage
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Top badge inside image
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          notice.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.apartment_outlined,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Bottom Title inside image
                                Text(
                                  notice.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Date Text
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            notice.date,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Arabic Description
                        Text(
                          notice.arabicDescription,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.textMain,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // English Description
                        Text(
                          notice.englishDescription,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Expected Interruption Banner
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: colors.inputFill,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: colors.inputBorder),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.access_time_outlined,
                                color: colors.primary,
                                size: 20,
                              ),
                              Text(
                                notice.expectedDuration,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textMain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }
}
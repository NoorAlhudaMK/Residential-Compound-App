import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:residential_compound_app/Data/Models/announcement_model.dart';
import 'package:residential_compound_app/Data/Repositories/community_repository.dart';
import 'package:http/http.dart' as https;
import '../../../Core/AppConstants/app_constants.dart';
import '../../../Core/CacheManager/cache_manager.dart';
import '../../../Core/Colors/app_colors.dart';
import '../BLoC/community_bloc.dart';
import '../BLoC/community_event.dart';
import '../BLoC/community_state.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return BlocProvider(
      create: (context) =>
          CommunityBloc(repository: CommunityRepository())
            ..add(LoadAnnouncements()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          appBar: _buildAppBar(colors),
          body: BlocBuilder<CommunityBloc, CommunityState>(
            builder: (context, state) {
              if (state.status == CommunityStatus.loading)
                return const Center(child: CircularProgressIndicator());
              return ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: state.announcements.length,
                itemBuilder: (context, index) =>
                    _buildAnnouncementCard(state.announcements[index], colors),
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(AppColors colors) => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(
      "التواصل المجتمعي",
      style: TextStyle(color: colors.textMain, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
  );

  Widget _buildAnnouncementCard(AnnouncementModel data, AppColors colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colors.secondaryBtnBg,
                child: Icon(Icons.campaign_outlined, color: colors.primary),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "إدارة المجمع",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colors.textMain,
                    ),
                  ),
                  Text(
                    "منذ فترة قصيرة",
                    style: TextStyle(color: colors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
              const Spacer(),
              _buildTag("إعلان", colors),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            data.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colors.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.subtitle,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          // إعادة تفعيل الصور هنا
          if (data.imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildImageWithToken(
                  '${AppConstants.baseUrl}${data.imageUrl}',
                ),
              ),
            ),

          const SizedBox(height: 15),
          // const Divider(),
          // const Text("12 إعجاب • 1 تعليق", style: TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildImageWithToken(String imageUrl) {
    return FutureBuilder<String?>(
      future: CacheManager.getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (kDebugMode) {
          print("Image URL: $imageUrl");
        }
        return FutureBuilder<https.Response>(
          future: https.get(
            Uri.parse(imageUrl),
            headers: {'Authorization': 'Bearer ${snapshot.data}'},
          ),
          builder: (context, resp) {
            if (resp.hasData && resp.data!.statusCode == 200) {
              return Image.memory(
                resp.data!.bodyBytes,
                height: 150,
                width: double.infinity,
                fit: BoxFit.contain,
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildTag(String text, AppColors colors) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: colors.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: colors.primary,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

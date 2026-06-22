import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../BLoC/community_bloc.dart';
import '../BLoC/community_event.dart';
import '../BLoC/community_state.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommunityBloc()..add(LoadAnnouncements()),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          appBar: _buildAppBar(),
          body: Column(
            children: [
              // _buildStaticTab(),
              Expanded(
                child: BlocBuilder<CommunityBloc, CommunityState>(
                  builder: (context, state) {
                    if (state.status == CommunityStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.status == CommunityStatus.failure) {
                      return Center(child: Text("خطأ: ${state.errorMessage}"));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: state.announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = state.announcements[index];
                        return _buildAnnouncementCard(
                          context,
                          index: index,
                          data: announcement,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "التواصل المجتمعي",
        style: TextStyle(color: Color(0xFF102C57), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      automaticallyImplyActions: false,
      automaticallyImplyLeading: false,
      // leading: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: CircleAvatar(
      //     backgroundColor: const Color(0xFFF1F5F9),
      //     child: IconButton(
      //       icon: const Icon(Icons.add, color: Color(0xFF102C57)),
      //       onPressed: () {
      //         // هنا نفتح صفحة إضافة إعلان جديد مستقبلاً
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildStaticTab() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
              ],
            ),
            child: const Text(
              "الإعلانات",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF102C57),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(
    BuildContext context, {
    required int index,
    required Map<String, dynamic> data,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFFF1F5F9),
                child: Icon(Icons.business, color: Color(0xFF102C57)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "إدارة المجمع",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      data['time'],
                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
              ),
              _buildTag(data['tag'], Color(data['tagColor'])),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            data['title'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF102C57),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data['content'],
            style: const TextStyle(
              color: Color(0xFF64748B),
              height: 1.5,
              fontSize: 13,
            ),
          ),

          if (data['hasImage']) _buildImagePlaceholder(),

          const SizedBox(height: 20),
          const Divider(color: Color(0xFFF1F5F9)),

          Row(
            children: [
              _buildInteractionBtn(
                context,
                icon: data['isLiked']
                    ? Icons.thumb_up_rounded
                    : Icons.thumb_up_off_alt_outlined,
                label: "إعجاب ${data['likes']}",
                color: data['isLiked'] ? Colors.blue : const Color(0xFF64748B),
                onTap: () =>
                    context.read<CommunityBloc>().add(ToggleLike(index)),
              ),
              const SizedBox(width: 20),
              _buildInteractionBtn(
                context,
                icon: Icons.chat_bubble_outline_rounded,
                label: "تعليقات ${data['comments']}",
                color: const Color(0xFF64748B),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.pink.shade50],
        ),
      ),
      child: const Icon(
        Icons.calendar_month_outlined,
        size: 50,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildInteractionBtn(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}

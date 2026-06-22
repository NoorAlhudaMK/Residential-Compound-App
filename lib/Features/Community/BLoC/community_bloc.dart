import 'package:flutter_bloc/flutter_bloc.dart';
import 'community_event.dart';
import 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc() : super(CommunityState()) {

    // معالجة تحميل الإعلانات
    on<LoadAnnouncements>((event, emit) async {
      emit(state.copyWith(status: CommunityStatus.loading));

      try {
        // محاكاة تأخير جلب البيانات من السيرفر
        await Future.delayed(const Duration(seconds: 1));

        final data = [
          {
            "tag": "عاجل",
            "tagColor": 0xFFFF0000, // Red
            "title": "إغلاق مؤقت للبوابة الشمالية",
            "content": "نود إعلامكم بأنه سيتم إغلاق البوابة الشمالية لأعمال الصيانة غداً من الساعة 9 صباحاً وحتى 12 ظهراً.",
            "time": "قبل ساعتين",
            "likes": 24,
            "comments": 5,
            "isLiked": false,
            "hasImage": false,
          },
          {
            "tag": "فعاليات",
            "tagColor": 0xFF9C27B0, // Purple
            "title": "دعوة: حفل شواء للعائلات",
            "content": "يسرنا دعوتكم لحفل الشواء السنوي لعائلات المجمع في الحديقة المركزية يوم الجمعة القادم.",
            "time": "أمس، 4:30 م",
            "likes": 42,
            "comments": 12,
            "isLiked": true,
            "hasImage": true,
          }
        ];

        emit(state.copyWith(status: CommunityStatus.success, announcements: data));
      } catch (e) {
        emit(state.copyWith(status: CommunityStatus.failure, errorMessage: e.toString()));
      }
    });

    // معالجة الضغط على زر الإعجاب
    on<ToggleLike>((event, emit) {
      final updatedAnnouncements = List<Map<String, dynamic>>.from(state.announcements);
      final item = updatedAnnouncements[event.index];

      bool currentStatus = item['isLiked'];
      item['isLiked'] = !currentStatus;
      item['likes'] = currentStatus ? item['likes'] - 1 : item['likes'] + 1;

      emit(state.copyWith(announcements: updatedAnnouncements));
    });
  }
}
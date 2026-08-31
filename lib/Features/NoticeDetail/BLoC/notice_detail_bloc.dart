import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Data/Models/notice_detail_model.dart';
import 'notice_detail_event.dart';
import 'notice_detail_state.dart';

class NoticeDetailBloc extends Bloc<NoticeDetailEvent, NoticeDetailState> {
  NoticeDetailBloc() : super(NoticeDetailLoaded(
    NoticeDetailModel(
      title: 'خدمة صيانة المياه',
      category: 'إشعار المجمع',
      date: 'الخميس • 26 حزيران',
      arabicDescription: 'صيانة لخدمة المياه يوم الخميس، من 10:00 إلى 13:00.',
      englishDescription: 'ستقوم فرق الصيانة بتحسين خط ربط المياه المشترك. يرجى تخزين أي كمية مياه قد تحتاجها قبل فترة العمل. ستستأنف الخدمات بمجرد اكتمال الفحص.',
      expectedDuration: 'الانقطاع المتوقع: ما يصل إلى ثلاث ساعات',
      imageUrl: 'assets/images/notice_details_image.png',
    ),
  )) {
    on<LoadNoticeDetail>((event, emit) {
      // جلب تفاصيل الإشعار إذا لزم الأمر
    });
  }
}
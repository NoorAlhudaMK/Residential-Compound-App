import '../../../Data/Models/notice_detail_model.dart';

abstract class NoticeDetailState {}

class NoticeDetailLoaded extends NoticeDetailState {
  final NoticeDetailModel notice;
  NoticeDetailLoaded(this.notice);
}
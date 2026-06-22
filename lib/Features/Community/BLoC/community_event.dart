abstract class CommunityEvent {}

// جلب البيانات من السيرفر
class LoadAnnouncements extends CommunityEvent {}

// التفاعل مع المنشور
class ToggleLike extends CommunityEvent {
  final int index;
  ToggleLike(this.index);
}

// فتح قسم التعليقات (أو إضافتها مستقبلاً)
class OpenComments extends CommunityEvent {
  final int index;
  OpenComments(this.index);
}
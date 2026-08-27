abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationsAsReadEvent extends NotificationEvent {
  final List<int> notificationIds;
  MarkNotificationsAsReadEvent(this.notificationIds);
}

class MarkSingleNotificationAsRead extends NotificationEvent {
  final int notificationId;
  MarkSingleNotificationAsRead(this.notificationId);
}
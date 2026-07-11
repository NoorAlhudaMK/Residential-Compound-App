import '../../../Data/Models/announcement_model.dart';

enum CommunityStatus { initial, loading, success, failure }

class CommunityState {
  final List<AnnouncementModel> announcements;
  final CommunityStatus status;
  final String? errorMessage;

  CommunityState({
    this.announcements = const [],
    this.status = CommunityStatus.initial,
    this.errorMessage,
  });

  CommunityState copyWith({
    final List<AnnouncementModel>? announcements,
    CommunityStatus? status,
    String? errorMessage,
  }) {
    return CommunityState(
      announcements: announcements ?? this.announcements,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
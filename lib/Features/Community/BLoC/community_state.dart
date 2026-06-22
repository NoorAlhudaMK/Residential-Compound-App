enum CommunityStatus { initial, loading, success, failure }

class CommunityState {
  final List<Map<String, dynamic>> announcements;
  final CommunityStatus status;
  final String? errorMessage;

  CommunityState({
    this.announcements = const [],
    this.status = CommunityStatus.initial,
    this.errorMessage,
  });

  CommunityState copyWith({
    List<Map<String, dynamic>>? announcements,
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
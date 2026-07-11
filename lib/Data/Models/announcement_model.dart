class AnnouncementModel {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'] == false ? "" : json['subtitle'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
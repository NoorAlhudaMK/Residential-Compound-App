class NoticeDetailModel {
  final String title;
  final String category;
  final String date;
  final String arabicDescription;
  final String englishDescription;
  final String expectedDuration;
  final String imageUrl;

  NoticeDetailModel({
    required this.title,
    required this.category,
    required this.date,
    required this.arabicDescription,
    required this.englishDescription,
    required this.expectedDuration,
    required this.imageUrl,
  });
}
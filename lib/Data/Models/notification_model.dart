class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String type;
  final String state;
  final String createDate;
  final String sentDate;
  final String? readDate;
  final String relatedModel;
  final int relatedResId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.state,
    required this.createDate,
    required this.sentDate,
    this.readDate,
    required this.relatedModel,
    required this.relatedResId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      state: json['state'] ?? '',
      createDate: json['create_date'] ?? '',
      sentDate: json['sent_date'] ?? '',
      readDate: json['read_date'],
      relatedModel: json['related_model'] ?? '',
      relatedResId: json['related_res_id'] ?? 0,
    );
  }
}
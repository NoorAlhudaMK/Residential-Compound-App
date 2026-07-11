class MaintenanceTicketModel {
  final int id;
  final String subject;
  final String description;
  final String categoryName;
  final String stageName;
  final String state;
  final double averageRating;
  final String? assignedUserName;
  final String? closedDate;

  MaintenanceTicketModel({
    required this.id,
    required this.subject,
    required this.description,
    required this.categoryName,
    required this.stageName,
    required this.state,
    required this.averageRating,
    this.assignedUserName,
    this.closedDate,
  });

  factory MaintenanceTicketModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceTicketModel(
      id: json['id'] ?? 0,
      subject: json['subject'] ?? "",
      description: json['description'] ?? "",
      categoryName: json['category_name'] ?? "",
      stageName: json['stage_name'] ?? "",
      state: json['state'] ?? "",
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      assignedUserName: json['assigned_user_name'] is String ? json['assigned_user_name'] : null,
      closedDate: json['closed_date'] as String?,
    );
  }
}
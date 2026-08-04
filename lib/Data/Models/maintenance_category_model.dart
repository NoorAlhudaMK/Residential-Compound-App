class MaintenanceCategoryModel {
  final int id;
  final String name;
  final String code;
  final String description;
  final int teamId;
  final bool active;

  MaintenanceCategoryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.teamId,
    required this.active,
  });

  factory MaintenanceCategoryModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      teamId: json['team_id'] ?? 0,
      active: json['active'] ?? true,
    );
  }
}
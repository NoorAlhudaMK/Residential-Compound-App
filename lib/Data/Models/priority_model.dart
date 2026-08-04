class PriorityModel {
  final String value;
  final String code;
  final String name;

  PriorityModel({
    required this.value,
    required this.code,
    required this.name,
  });

  factory PriorityModel.fromJson(Map<String, dynamic> json) {
    return PriorityModel(
      value: json['value'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
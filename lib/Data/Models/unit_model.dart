class UnitModel {
  final int id;
  final String name;
  final String code;
  final int buildingId;
  final String buildingName;
  final String state;
  final double area;
  final int bedrooms;
  final int bathrooms;

  UnitModel({
    required this.id, required this.name, required this.code,
    required this.buildingId, required this.buildingName,
    required this.state, required this.area,
    required this.bedrooms, required this.bathrooms,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      buildingId: json['building_id'],
      buildingName: json['building_name'],
      state: json['state'],
      area: (json['area'] as num).toDouble(),
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'building_id': buildingId,
      'building_name': buildingName,
      'state': state,
      'area': area,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
    };
  }
}
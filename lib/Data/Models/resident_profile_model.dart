import 'unit_model.dart';

class ResidentProfileModel {
  final int id;
  final String name;
  final String residentType;
  final String state;
  final String phone;
  final String email;
  final UnitModel primaryUnit;
  final List<UnitModel> units;

  ResidentProfileModel({
    required this.id, required this.name, required this.residentType,
    required this.state, required this.phone, required this.email,
    required this.primaryUnit, required this.units,
  });

  factory ResidentProfileModel.fromJson(Map<String, dynamic> json) {
    return ResidentProfileModel(
      id: json['id'],
      name: json['name'],
      residentType: json['resident_type'],
      state: json['state'],
      phone: json['phone'],
      email: json['email'],
      primaryUnit: UnitModel.fromJson(json['primary_unit']),
      units: (json['units'] as List).map((i) => UnitModel.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'resident_type': residentType,
      'state': state,
      'phone': phone,
      'email': email,
      'primary_unit': primaryUnit.toJson(),
      'units': units.map((unit) => unit.toJson()).toList(),
    };
  }
}
import 'resident_profile_model.dart';
import 'unit_model.dart';

class UserModel {
  final int id;
  final String name;
  final String login;
  final String role;
  final List<String>? allowedApps;
  final List<UnitModel>? units;
  final List<ResidentProfileModel> residentProfiles;
  final String? token;

  UserModel({
    required this.id,
    required this.name,
    required this.login,
    required this.role,
    required this.allowedApps,
    required this.units,
    required this.residentProfiles,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      login: json['login'] ?? '',
      role: json['role'] ?? 'user',

      allowedApps: json['allowed_apps'] != null
          ? List<String>.from(json['allowed_apps'])
          : [],

      units: json['units'] != null
          ? (json['units'] as List).map((i) => UnitModel.fromJson(i)).toList()
          : [],

      residentProfiles: json['resident_profiles'] != null
          ? (json['resident_profiles'] as List).map((i) => ResidentProfileModel.fromJson(i)).toList()
          : [],

      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'login': login,
      'role': role,
      'allowed_apps': allowedApps,
      'units': units!.map((unit) => unit.toJson()).toList(),
      'resident_profiles': residentProfiles.map((profile) => profile.toJson()).toList(),
      'token': token,
    };
  }
}
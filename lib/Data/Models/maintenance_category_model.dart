class MaintenanceCategoryModel {
  final int id;
  final String name;
  final String icon;
  final int color;
  final int teamId;
  final String teamName;
  final bool paidService;
  final double servicePrice;
  final int currencyId;
  final String currency;
  final double responseHours;
  final double resolutionHours;

  MaintenanceCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.teamId,
    required this.teamName,
    required this.paidService,
    required this.servicePrice,
    required this.currencyId,
    required this.currency,
    required this.responseHours,
    required this.resolutionHours,
  });

  factory MaintenanceCategoryModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? 0,
      teamId: json['team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      paidService: json['paid_service'] ?? false,
      servicePrice: (json['service_price'] ?? 0.0).toDouble(),
      currencyId: json['currency_id'] ?? 1,
      currency: json['currency'] ?? 'USD',
      responseHours: (json['response_hours'] ?? 0.0).toDouble(),
      resolutionHours: (json['resolution_hours'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
      'team_id': teamId,
      'team_name': teamName,
      'paid_service': paidService,
      'service_price': servicePrice,
      'currency_id': currencyId,
      'currency': currency,
      'response_hours': responseHours,
      'resolution_hours': resolutionHours,
    };
  }
}
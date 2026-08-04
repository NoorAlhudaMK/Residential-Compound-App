class VisitorModel {
  final int id;
  final String visitorName;
  final String? visitorPhone;
  final String visitType;
  final String status;
  final String? visitDatetime;
  final String qrToken;
  final String? unitName;
  final String? validFrom;
  final String? validTo;
  final bool hasCar;
  final String? carPlate;

  VisitorModel({
    required this.id,
    required this.visitorName,
    this.visitorPhone,
    required this.visitType,
    required this.status,
    this.visitDatetime,
    required this.qrToken,
    this.unitName,
    this.validFrom,
    this.validTo,
    required this.hasCar,
    this.carPlate,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'] ?? 0,
      visitorName: json['visitor_name'] ?? '',
      visitorPhone: json['visitor_phone'] is String ? json['visitor_phone'] : null,
      visitType: json['visit_type'] ?? '',
      status: json['status'] ?? '',
      visitDatetime: json['visit_datetime']?.toString(),
      qrToken: json['qr_token'] ?? '',
      unitName: json['unit_name'] is String ? json['unit_name'] : null,
      validFrom: json['valid_from']?.toString(),
      validTo: json['valid_to']?.toString(),
      hasCar: json['has_car'] ?? false,
      carPlate: json['car_plate'] is String ? json['car_plate'] : null,
    );
  }
}
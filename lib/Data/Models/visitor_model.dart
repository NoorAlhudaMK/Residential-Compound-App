class VisitorModel {
  final int id;
  final String visitorName;
  final String visitType;
  final String status;
  final String? visitDatetime;
  final String qrToken;

  VisitorModel({
    required this.id,
    required this.visitorName,
    required this.visitType,
    required this.status,
    this.visitDatetime,
    required this.qrToken,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      id: json['id'],
      visitorName: json['visitor_name'],
      visitType: json['visit_type'],
      status: json['status'],
      visitDatetime: json['visit_datetime']?.toString(),
      qrToken: json['qr_token'],
    );
  }
}

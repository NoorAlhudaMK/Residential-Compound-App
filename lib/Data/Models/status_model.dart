class StatusModel {
  final int id;
  final String name;
  final int sequence;
  final bool isDone;
  final bool isCancelled;

  StatusModel({
    required this.id, required this.name, required this.sequence,
    required this.isDone, required this.isCancelled,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      id: json['id'],
      name: json['name'],
      sequence: json['sequence'],
      isDone: json['is_done'],
      isCancelled: json['is_cancelled'],
    );
  }
}
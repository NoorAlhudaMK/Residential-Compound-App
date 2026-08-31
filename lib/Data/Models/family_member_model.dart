class FamilyMember {
  final String name;
  final String role;

  FamilyMember({required this.name, required this.role});

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(name: json['name'] ?? '', role: json['role'] ?? '');
  }
}

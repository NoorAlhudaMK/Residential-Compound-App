import 'package:flutter/material.dart';

class BookingState {
  final int selectedFacilityIndex;
  final DateTime selectedDate;
  final List<Map<String, dynamic>> facilities;

  BookingState({
    this.selectedFacilityIndex = 0,
    required this.selectedDate,
    this.facilities = const [
      {"name": "ملعب البادل", "status": "متاح للحجز", "icon": Icons.sports_tennis, "colors": [Color(0xFFFFB74D), Color(0xFFFB8C00)]},
      {"name": "الحديقة المركزية", "status": "مفتوح", "icon": Icons.park, "colors": [Color(0xFF4DB6AC), Color(0xFF00897B)]},
    ],
  });
}
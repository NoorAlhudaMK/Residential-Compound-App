import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import 'visitors_event.dart';
import 'visitors_state.dart';

class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  VisitorBloc() : super(VisitorState()) {

    on<ToggleTab>((event, emit) {
      List<Map<String, dynamic>> history = [];
      if (event.index == 0) {
        history = [
          {"name": "أشرف شروفي", "type": "عائلة", "time": "8:30 ص", "status": "زيارة منتظرة", "icon": Icons.family_restroom},
          {"name": "محمد العبدالله", "type": "توصيل", "time": "10:30 ص", "status": "تم الدخول", "icon": Icons.delivery_dining},
          {"name": "سارة الخالدي", "type": "عائلة", "time": "أمس، 08:00 م", "status": "مكتمل", "icon": Icons.family_restroom},
          {"name": "شاكر مشكور الشكراني", "type": "صيانة", "time": "14 أبريل", "status": "ملغي", "icon": Icons.build_outlined},
        ];
      }
      emit(VisitorState(activeTab: event.index, visitHistory: history));
    });

    on<GeneratePermit>((event, emit) async {
      emit(state.copyWith(isGenerating: true));

      await Future.delayed(const Duration(seconds: 1));

      DateTime now = DateTime.now();
      String datePart = DateFormat('yyyyMMdd').format(now);

      String randomPart = (Random().nextInt(900000) + 100000).toString();

      String finalQrData = datePart + randomPart;

      emit(state.copyWith(
        isGenerating: false,
        generatedVisitorName: event.visitorName,
        qrCodeData: finalQrData,
        activeTab: 1,
      ));
    });
  }
}
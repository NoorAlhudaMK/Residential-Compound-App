import '../../../Data/Models/visitor_model.dart';

class VisitorState {
  final int activeTab;
  final List<VisitorModel> visitHistory;
  final VisitorModel? lastCreatedVisitor;
  final bool isGenerating;

  final DateTime selectedDate;
  final bool hasCar;
  final int companionsCount;
  final String relation;

  VisitorState({
    this.activeTab = 1,
    this.visitHistory = const [],
    this.lastCreatedVisitor,
    this.isGenerating = false,
    DateTime? selectedDate,
    this.hasCar = false,
    this.companionsCount = 0,
    this.relation = "",
  }) : selectedDate = selectedDate ?? DateTime.now();

  VisitorState copyWith({
    int? activeTab,
    List<VisitorModel>? visitHistory,
    VisitorModel? lastCreatedVisitor,
    bool? isGenerating,
    DateTime? selectedDate,
    bool? hasCar,
    int? companionsCount,
    final String? relation,
  }) {
    return VisitorState(
      activeTab: activeTab ?? this.activeTab,
      visitHistory: visitHistory ?? this.visitHistory,
      lastCreatedVisitor: lastCreatedVisitor ?? this.lastCreatedVisitor,
      isGenerating: isGenerating ?? this.isGenerating,
      selectedDate: selectedDate ?? this.selectedDate,
      hasCar: hasCar ?? this.hasCar,
      companionsCount: companionsCount ?? this.companionsCount,
      relation: relation ?? this.relation,
    );
  }
}
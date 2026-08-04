import '../../../../Data/Models/visitor_model.dart';

class AddVisitorState {
  final int currentStep;
  final VisitorModel? lastCreatedVisitor;
  final bool isGenerating;

  final DateTime selectedDate;
  final bool isTimeSelected;

  final bool hasCar;
  final String? errorMessage;

  AddVisitorState({
    this.currentStep = 1,
    this.lastCreatedVisitor,
    this.isGenerating = false,
    DateTime? selectedDate,
    this.isTimeSelected = false,
    this.hasCar = false,
    this.errorMessage,
  }) : selectedDate = selectedDate ?? DateTime.now();

  AddVisitorState copyWith({
    int? currentStep,
    VisitorModel? lastCreatedVisitor,
    bool? isGenerating,
    DateTime? selectedDate,
    bool? isTimeSelected,
    bool? hasCar,
    String? errorMessage,
  }) {
    return AddVisitorState(
      currentStep: currentStep ?? this.currentStep,
      lastCreatedVisitor: lastCreatedVisitor ?? this.lastCreatedVisitor,
      isGenerating: isGenerating ?? this.isGenerating,
      selectedDate: selectedDate ?? this.selectedDate,
      isTimeSelected: isTimeSelected ?? this.isTimeSelected,
      hasCar: hasCar ?? this.hasCar,
      errorMessage: errorMessage,
    );
  }
}
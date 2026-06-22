class VisitorState {
  final int activeTab;
  final List<Map<String, dynamic>> visitHistory;
  final String? generatedVisitorName;
  final String? qrCodeData;
  final bool isGenerating;

  VisitorState({
    this.activeTab = 1,
    this.visitHistory = const [],
    this.generatedVisitorName,
    this.qrCodeData,
    this.isGenerating = false,
  });

  VisitorState copyWith({
    int? activeTab,
    List<Map<String, dynamic>>? visitHistory,
    String? generatedVisitorName,
    String? qrCodeData,
    bool? isGenerating,
  }) {
    return VisitorState(
      activeTab: activeTab ?? this.activeTab,
      visitHistory: visitHistory ?? this.visitHistory,
      generatedVisitorName: generatedVisitorName ?? this.generatedVisitorName,
      qrCodeData: qrCodeData ?? this.qrCodeData,
      isGenerating: isGenerating ?? this.isGenerating,
    );
  }
}
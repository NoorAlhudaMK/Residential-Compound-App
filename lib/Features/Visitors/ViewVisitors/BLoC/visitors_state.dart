import '../../../../Data/Models/visitor_model.dart';

class VisitorState {
  final bool isLoading;
  final bool isMoreLoading;
  final List<VisitorModel> visitHistory;
  final List<VisitorModel> filteredVisitors;
  final String? errorMessage;
  final String searchQuery;
  final String? currentStatus;
  final int currentPage;
  final bool hasMore;

  VisitorState({
    this.isLoading = false,
    this.isMoreLoading = false,
    this.visitHistory = const [],
    this.filteredVisitors = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.currentStatus,
    this.currentPage = 1,
    this.hasMore = true,
  });

  VisitorState copyWith({
    bool? isLoading,
    bool? isMoreLoading,
    List<VisitorModel>? visitHistory,
    List<VisitorModel>? filteredVisitors,
    String? errorMessage,
    String? searchQuery,
    String? currentStatus,
    int? currentPage,
    bool? hasMore,
  }) {
    return VisitorState(
      isLoading: isLoading ?? this.isLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      visitHistory: visitHistory ?? this.visitHistory,
      filteredVisitors: filteredVisitors ?? this.filteredVisitors,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      currentStatus: currentStatus ?? this.currentStatus,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
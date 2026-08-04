abstract class VisitorEvent {}

class FetchVisitors extends VisitorEvent {
  final String? status;
  final String? search;
  final int page;
  final int perPage;
  final bool isPagination;

  FetchVisitors({
    this.status,
    this.search,
    this.page = 1,
    this.perPage = 15,
    this.isPagination = false,
  });
}

class SearchVisitors extends VisitorEvent {
  final String query;
  SearchVisitors(this.query);
}
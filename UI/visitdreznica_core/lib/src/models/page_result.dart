class PageResult<T> {
  PageResult({required this.items, required this.totalCount, required this.page, required this.pageSize});

  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;

  int get totalPages => totalCount == 0 ? 1 : (totalCount / pageSize).ceil();

  bool get hasNext => page < totalPages;

  bool get hasPrevious => page > 1;

  factory PageResult.fromJson(dynamic json, T Function(Map<String, dynamic>) itemFromJson) {
    final map = json as Map<String, dynamic>;

    return PageResult(
      items: (map['items'] as List<dynamic>).map((x) => itemFromJson(x as Map<String, dynamic>)).toList(),
      totalCount: map['totalCount'] as int,
      page: map['page'] as int,
      pageSize: map['pageSize'] as int,
    );
  }
}
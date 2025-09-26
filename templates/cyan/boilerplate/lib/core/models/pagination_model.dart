import 'package:intl/intl.dart';

class PaginationData<T> {
  int? limit;
  int? offset;
  int? total;
  String? search;
  DateTime? date;
  T? list;

  PaginationData({
    this.limit,
    this.offset,
    this.total,
    this.search = "",
    this.list,
    this.date,
  });

  PaginationData copyWith({
    int? limit,
    int? offset,
    int? total,
    String? search,
    DateTime? date,
  }) {
    return PaginationData(
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      search: search ?? this.search,
      date: date ?? this.date,
    );
  }

  PaginationData.initial({
    this.limit = 10,
    this.search,
    this.date,
  }) {
    offset = 0 - limit!;
    total = 0;
  }

  PaginationData.unlimited({
    this.search,
    this.date,
  }) {
    limit = null;
    offset = null;
  }

  void clearData() => list = null;

  bool get canLoadMore {
    if (limit == null || offset == null || total == null) return false;
    return (offset ?? 0) + (limit ?? 0) < (total ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      "limit": this.limit,
      "offset": (this.offset ?? 0) + (this.limit ?? 0),
      if (search != null) "search": this.search,
      if (this.date != null) "date": DateFormat("yyyy-MM-dd").format(this.date!),
    };
  }

  factory PaginationData.fromJson(Map<String, dynamic> json) {
    return PaginationData(
      limit: json['limit'],
      offset: json['offset'],
      total: json['total'],
      search: json['search'],
    );
  }
}

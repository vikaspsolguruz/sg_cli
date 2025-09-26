import 'package:newarch/core/models/filter_model.dart';

/// Filter model for Project listing with required .initial() pattern
class ProjectFilterModel extends FilterModel {
  final String? category;
  final String? status;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final bool? isFavorite;
  final List<String>? tags;

  const ProjectFilterModel._({
    this.category,
    this.status,
    this.dateFrom,
    this.dateTo,
    this.isFavorite,
    this.tags,
  });

  /// Required initial constructor - creates default/empty filters
  factory ProjectFilterModel.initial() {
    return const ProjectFilterModel._();
  }

  /// Named constructor for specific filter combinations
  factory ProjectFilterModel.withCategory(String category) {
    return ProjectFilterModel._(category: category);
  }

  factory ProjectFilterModel.withStatus(String status) {
    return ProjectFilterModel._(status: status);
  }

  factory ProjectFilterModel.favorites() {
    return const ProjectFilterModel._(isFavorite: true);
  }

  ProjectFilterModel copyWith({
    String? category,
    String? status,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool? isFavorite,
    List<String>? tags,
  }) {
    return ProjectFilterModel._(
      category: category ?? this.category,
      status: status ?? this.status,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
    );
  }

  @override
  ProjectFilterModel clear() => ProjectFilterModel.initial();

  @override
  bool get hasFilters {
    return category != null || status != null || dateFrom != null || dateTo != null || isFavorite != null || (tags != null && tags!.isNotEmpty);
  }

  @override
  int get filterCount {
    int count = 0;
    if (category != null) count++;
    if (status != null) count++;
    if (dateFrom != null) count++;
    if (dateTo != null) count++;
    if (isFavorite != null) count++;
    if (tags != null && tags!.isNotEmpty) count++;
    return count;
  }

  @override
  List<Object?> get props => [
    category,
    status,
    dateFrom,
    dateTo,
    isFavorite,
    tags,
  ];

  /// Convert to JSON for API calls
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (category != null) data['category'] = category;
    if (status != null) data['status'] = status;
    if (dateFrom != null) data['dateFrom'] = dateFrom!.toIso8601String();
    if (dateTo != null) data['dateTo'] = dateTo!.toIso8601String();
    if (isFavorite != null) data['isFavorite'] = isFavorite;
    if (tags != null && tags!.isNotEmpty) data['tags'] = tags;

    return data;
  }

  /// For backward compatibility
  bool get isFilterApplied => hasFilters;
}

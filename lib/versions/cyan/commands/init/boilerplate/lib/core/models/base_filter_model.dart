import 'package:equatable/equatable.dart';

/// Base abstract class for all filter models
abstract class BaseFilterModel extends Equatable {
  const BaseFilterModel();

  /// Abstract factory method that subclasses must implement
  /// This ensures every filter has an .initial() constructor
  static T initial<T extends BaseFilterModel>() {
    throw UnimplementedError('Subclass must implement static initial() method');
  }

  /// Abstract method for clearing filters
  BaseFilterModel clear();

  /// Abstract method for checking if filters are applied
  bool get hasFilters;

  /// Abstract method for getting filter count
  int get filterCount;
}

/// Example implementation for ProjectFilterModel
class ProjectFilterModel extends BaseFilterModel {
  final String? search;
  final List<String> categories;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? status;

  const ProjectFilterModel({
    this.search,
    this.categories = const [],
    this.dateFrom,
    this.dateTo,
    this.status,
  });

  /// Required .initial() constructor pattern
  const ProjectFilterModel.initial() : search = null, categories = const [], dateFrom = null, dateTo = null, status = null;

  @override
  ProjectFilterModel clear() => const ProjectFilterModel.initial();

  @override
  bool get hasFilters => search?.isNotEmpty == true || categories.isNotEmpty || dateFrom != null || dateTo != null || status?.isNotEmpty == true;

  @override
  int get filterCount {
    int count = 0;
    if (search?.isNotEmpty == true) count++;
    if (categories.isNotEmpty) count++;
    if (dateFrom != null) count++;
    if (dateTo != null) count++;
    if (status?.isNotEmpty == true) count++;
    return count;
  }

  ProjectFilterModel copyWith({
    String? search,
    List<String>? categories,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? status,
  }) {
    return ProjectFilterModel(
      search: search ?? this.search,
      categories: categories ?? this.categories,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [search, categories, dateFrom, dateTo, status];
}

/// Example implementation for UserFilterModel
class UserFilterModel extends BaseFilterModel {
  final String? search;
  final List<String> roles;
  final bool? isActive;

  const UserFilterModel({
    this.search,
    this.roles = const [],
    this.isActive,
  });

  /// Required .initial() constructor pattern
  const UserFilterModel.initial() : search = null, roles = const [], isActive = null;

  @override
  UserFilterModel clear() => const UserFilterModel.initial();

  @override
  bool get hasFilters => search?.isNotEmpty == true || roles.isNotEmpty || isActive != null;

  @override
  int get filterCount {
    int count = 0;
    if (search?.isNotEmpty == true) count++;
    if (roles.isNotEmpty) count++;
    if (isActive != null) count++;
    return count;
  }

  UserFilterModel copyWith({
    String? search,
    List<String>? roles,
    bool? isActive,
  }) {
    return UserFilterModel(
      search: search ?? this.search,
      roles: roles ?? this.roles,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [search, roles, isActive];
}

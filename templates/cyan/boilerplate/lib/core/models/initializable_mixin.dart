import 'package:equatable/equatable.dart';

/// Mixin that enforces .initial() pattern through documentation and runtime checks
mixin InitializableMixin {
  /// Documentation contract: Implementing classes MUST provide a .initial() constructor
  /// Example: MyFilter.initial() : this(field1: defaultValue, field2: defaultValue);
}

/// Usage example with the mixin approach
class ProjectFilterMixin extends Equatable with InitializableMixin {
  final String? search;
  final List<String> categories;
  final String? status;

  const ProjectFilterMixin({
    this.search,
    this.categories = const [],
    this.status,
  });

  /// Required .initial() constructor - enforced by convention
  ProjectFilterMixin.initial() : search = null, categories = const [], status = null;

  ProjectFilterMixin copyWith({
    String? search,
    List<String>? categories,
    String? status,
  }) {
    return ProjectFilterMixin(
      search: search ?? this.search,
      categories: categories ?? this.categories,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [search, categories, status];
}

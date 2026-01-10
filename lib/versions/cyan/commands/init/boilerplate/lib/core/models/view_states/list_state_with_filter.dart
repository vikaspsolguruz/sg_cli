import 'package:flutter/material.dart';
import 'package:newarch/core/enums/process_state.dart';
import 'package:newarch/core/models/filter_model.dart';
import 'package:newarch/core/models/pagination_model.dart';
import 'package:newarch/core/models/view_states/view_state.dart';

class ListStateWithFilter<T, F extends FilterModel> extends ViewState {
  final List<T> items;
  final F filter;
  final PaginationData? paginationData;
  @override
  final ProcessState status;
  @override
  final String? errorMessage;
  final bool isSearching;
  final bool isLoadingMore;
  final TextEditingController? searchController;
  final bool Function(ListStateWithFilter<T, F> state)? hasDataOverride;

  ListStateWithFilter._({
    required this.items,
    required this.filter,
    this.paginationData,
    required this.status,
    this.errorMessage,
    required this.isSearching,
    required this.isLoadingMore,
    this.searchController,
    this.hasDataOverride,
  });

  factory ListStateWithFilter.initial({
    required F Function() createInitialFilter,
    bool isPaginated = true,
    bool hasSearch = false,
    bool Function(ListStateWithFilter<T, F> state)? hasDataOverride,
    int pageLimit = 10,
  }) {
    return ListStateWithFilter._(
      items: const [],
      filter: createInitialFilter(),
      // This enforces .initial() pattern!
      paginationData: isPaginated ? PaginationData.initial(limit: pageLimit) : null,
      status: ProcessState.loading,
      isSearching: false,
      isLoadingMore: false,
      searchController: hasSearch ? TextEditingController() : null,
      hasDataOverride: hasDataOverride,
    );
  }

  @override
  bool get hasData => (hasDataOverride?.call(this) ?? true) && items.isNotEmpty;

  @override
  bool get isEmpty => items.isEmpty && status == ProcessState.success;

  bool get isPaginated => paginationData != null;

  bool get hasSearch => searchController != null;

  String? get currentSearch => hasSearch && searchController!.text.trim().isNotEmpty ? searchController!.text.trim() : null;

  bool get canLoadMore => isPaginated && paginationData!.canLoadMore && !isLoading;

  ListStateWithFilter<T, F> copyWith({
    List<T>? items,
    F? filter,
    PaginationData? paginationData,
    ProcessState? status,
    String? errorMessage,
    bool? isSearching,
    bool? isLoadingMore,
    TextEditingController? searchController,
    bool Function(ListStateWithFilter<T, F> state)? hasDataOverride,
  }) {
    return ListStateWithFilter._(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      paginationData: paginationData ?? this.paginationData,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isSearching: isSearching ?? this.isSearching,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchController: searchController ?? this.searchController,
      hasDataOverride: hasDataOverride ?? this.hasDataOverride,
    );
  }

  @override
  void dispose() {
    searchController?.dispose();
  }

  @override
  List<Object?> get props => [
    items,
    filter,
    paginationData,
    status,
    errorMessage,
    isSearching,
    isLoadingMore,
  ];
}

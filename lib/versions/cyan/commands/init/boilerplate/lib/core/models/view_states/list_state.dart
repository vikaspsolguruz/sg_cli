import 'package:flutter/material.dart';
import 'package:newarch/core/enums/process_state.dart';
import 'package:newarch/core/models/pagination_model.dart';
import 'package:newarch/core/models/view_states/view_state.dart';

class ListState<T> extends ViewState {
  final List<T> items;
  final PaginationData? paginationData;
  @override
  final ProcessState status;
  @override
  final String? errorMessage;
  final bool isSearching;
  final bool isLoadingMore;
  final TextEditingController? searchController;
  final bool Function(ListState<T> state)? hasDataOverride;

  ListState._({
    required this.items,
    this.paginationData,
    required this.status,
    this.errorMessage,
    required this.isSearching,
    required this.isLoadingMore,
    this.searchController,
    this.hasDataOverride,
  });

  ListState.initial({
    bool isPaginated = true,
    bool hasSearch = false,
    this.hasDataOverride,
  }) : items = const [],
       paginationData = isPaginated ? PaginationData.initial(limit: 15) : null,
       status = ProcessState.loading,
       // 🎯 Loading is initial state!
       errorMessage = null,
       isSearching = false,
       isLoadingMore = false,
       searchController = hasSearch ? TextEditingController() : null;

  ListState.loading({
    List<T>? currentItems,
    bool isPaginated = true,
    TextEditingController? existingController,
    this.hasDataOverride,
  }) : items = currentItems ?? const [],
       paginationData = isPaginated ? PaginationData.initial(limit: 15) : null,
       status = ProcessState.loading,
       errorMessage = null,
       isSearching = false,
       isLoadingMore = false,
       searchController = existingController;

  ListState.success({
    required this.items,
    this.paginationData,
    this.isSearching = false,
    this.searchController,
    this.hasDataOverride,
  }) : status = ProcessState.success,
       errorMessage = null,
       isLoadingMore = false;

  ListState.error({
    required String error,
    List<T>? currentItems,
    PaginationData? currentPagination,
    this.searchController,
    this.hasDataOverride,
  }) : items = currentItems ?? const [],
       paginationData = currentPagination,
       status = ProcessState.error,
       errorMessage = error,
       isSearching = false,
       isLoadingMore = false;

  ListState.loadingMore({
    required this.items,
    required this.paginationData,
    this.isSearching = false,
    this.searchController,
    this.hasDataOverride,
  }) : status = ProcessState.success,
       errorMessage = null,
       isLoadingMore = true;

  ListState.searching({
    bool isPaginated = true,
    required this.searchController,
    this.hasDataOverride,
  }) : items = const [],
       paginationData = isPaginated ? PaginationData.initial(limit: 15) : null,
       status = ProcessState.loading,
       errorMessage = null,
       isSearching = true,
       isLoadingMore = false;

  @override
  bool get hasData => hasDataOverride?.call(this) ?? items.isNotEmpty;

  @override
  bool get isEmpty => items.isEmpty && status == ProcessState.success;

  bool get isPaginated => paginationData != null;

  bool get hasSearch => searchController != null;

  String? get currentSearch => hasSearch && searchController!.text.trim().isNotEmpty ? searchController!.text.trim() : null;

  bool get canLoadMore => isPaginated && paginationData!.canLoadMore && !isLoading;

  ListState<T> copyWith({
    List<T>? items,
    PaginationData? paginationData,
    ProcessState? status,
    String? errorMessage,
    bool? isSearching,
    bool? isLoadingMore,
    TextEditingController? searchController,
    bool Function(ListState<T> state)? hasDataOverride,
  }) {
    return ListState._(
      items: items ?? this.items,
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
    paginationData,
    status,
    errorMessage,
    isSearching,
    isLoadingMore,
  ];
}

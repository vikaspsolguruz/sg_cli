import 'package:flutter/material.dart';
import 'package:max_arch/core/enums/process_state.dart';
import 'package:max_arch/core/models/pagination_data_model.dart';
import 'package:max_arch/core/models/view_states/view_state.dart';

/// 🔥 LIST STATE - List with pagination & search (no filter)
///
/// < ItemType >
class ListState<I> extends ViewState {
  final List<I> items;
  final PaginationData? paginationData;
  @override
  final ProcessState state;
  @override
  final String? errorMessage;
  final bool isSearching;
  final bool isLoadingMore;
  final TextEditingController? searchController;
  final bool Function(ListState<I> state)? hasDataOverride;

  ListState._({
    required this.items,
    this.paginationData,
    required this.state,
    this.errorMessage,
    required this.isSearching,
    required this.isLoadingMore,
    this.searchController,
    this.hasDataOverride,
  });

  ListState.initial({
    bool isPaginated = true,
    bool hasSearch = false,
    int? pageLimit,
    this.hasDataOverride,
  }) : items = const [],
       paginationData = isPaginated ? PaginationData.initial(limit: pageLimit) : null,
       state = ProcessState.loading,
       errorMessage = null,
       isSearching = false,
       isLoadingMore = false,
       searchController = hasSearch ? TextEditingController() : null;


  @override
  bool get hasData => hasDataOverride?.call(this) ?? items.isNotEmpty;

  @override
  bool get isEmpty => items.isEmpty && state == ProcessState.success;

  bool get isPaginated => paginationData != null;

  bool get hasSearch => searchController != null;

  String? get currentSearch => hasSearch && searchController!.text.trim().isNotEmpty ? searchController!.text.trim() : null;

  bool get canLoadMore => isPaginated && paginationData!.canLoadMore && !isLoading;

  ListState<I> copyWith({
    List<I>? items,
    PaginationData? paginationData,
    ProcessState? state,
    String? errorMessage,
    bool? isSearching,
    bool? isLoadingMore,
    TextEditingController? searchController,
    bool Function(ListState<I> state)? hasDataOverride,
  }) {
    return ListState._(
      items: items ?? this.items,
      paginationData: paginationData ?? this.paginationData,
      state: state ?? this.state,
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
    state,
    errorMessage,
    isSearching,
    isLoadingMore,
  ];
}

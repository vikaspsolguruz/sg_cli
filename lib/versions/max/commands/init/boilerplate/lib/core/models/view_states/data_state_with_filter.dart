import 'package:flutter/material.dart';
import 'package:max_arch/core/enums/process_state.dart';
import 'package:max_arch/core/models/filter_model.dart';
import 'package:max_arch/core/models/view_states/view_state.dart';
import 'package:max_arch/core/models/wrapped_model.dart';

/// 🔥 DATA STATE WITH FILTER - Single data object with search & filter support
///
/// < DataType, FilterType >
class DataStateWithFilter<D, F extends FilterModel> extends ViewState {
  final D? data;
  final F filter;
  @override
  final ProcessState state;
  @override
  final String? errorMessage;
  final bool isSearching;
  final TextEditingController? searchController;
  final bool Function(DataStateWithFilter<D, F> state)? hasDataOverride;

  DataStateWithFilter._({
    this.data,
    required this.filter,
    required this.state,
    this.errorMessage,
    required this.isSearching,
    this.searchController,
    this.hasDataOverride,
  });

  factory DataStateWithFilter.initial({
    required F Function() createInitialFilter,
    bool hasSearch = false,
    bool Function(DataStateWithFilter<D, F> state)? hasDataOverride,
  }) {
    return DataStateWithFilter._(
      filter: createInitialFilter(),
      state: ProcessState.loading,
      isSearching: false,
      searchController: hasSearch ? TextEditingController() : null,
      hasDataOverride: hasDataOverride,
    );
  }

  @override
  bool get hasData => hasDataOverride?.call(this) ?? (data != null && state == ProcessState.success);

  @override
  bool get isEmpty => data == null && state == ProcessState.success;

  bool get hasSearch => searchController != null;

  String? get currentSearch => hasSearch && searchController!.text.trim().isNotEmpty ? searchController!.text.trim() : null;

  DataStateWithFilter<D, F> copyWith({
    Wrapped<D?>? data,
    F? filter,
    ProcessState? state,
    String? errorMessage,
    bool? isSearching,
    TextEditingController? searchController,
    bool Function(DataStateWithFilter<D, F> state)? hasDataOverride,
  }) {
    return DataStateWithFilter._(
      data: data != null ? data.value : this.data,
      filter: filter ?? this.filter,
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      isSearching: isSearching ?? this.isSearching,
      searchController: searchController ?? this.searchController,
      hasDataOverride: hasDataOverride ?? this.hasDataOverride,
    );
  }

  @override
  void dispose() {
    searchController?.dispose();
  }

  @override
  List<Object?> get props => [data, filter, state, errorMessage, isSearching];
}

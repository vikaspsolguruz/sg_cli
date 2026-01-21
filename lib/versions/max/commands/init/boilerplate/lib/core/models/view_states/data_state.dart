import 'package:flutter/material.dart';
import 'package:max_arch/core/enums/process_state.dart';
import 'package:max_arch/core/models/view_states/view_state.dart';
import 'package:max_arch/core/models/wrapped_model.dart';

/// 🔥 DATA STATE - Single data object with search support
///
/// < DataType >
class DataState<D> extends ViewState {
  final D? data;
  @override
  final ProcessState state;
  @override
  final String? errorMessage;
  final bool isSearching;
  final TextEditingController? searchController;
  final bool Function(DataState<D> state)? hasDataOverride;

  DataState._({
    this.data,
    required this.state,
    this.errorMessage,
    required this.isSearching,
    this.searchController,
    this.hasDataOverride,
  });

  factory DataState.initial({
    bool hasSearch = false,
    bool Function(DataState<D> state)? hasDataOverride,
  }) {
    return DataState._(
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

  DataState<D> copyWith({
    Wrapped<D?>? data,
    ProcessState? state,
    String? errorMessage,
    bool? isSearching,
    TextEditingController? searchController,
    bool Function(DataState<D> state)? hasDataOverride,
  }) {
    return DataState._(
      data: data != null ? data.value : this.data,
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
  List<Object?> get props => [
    data,
    state,
    errorMessage,
    isSearching,
  ];
}

import 'package:flutter/material.dart';
import 'package:newarch/core/enums/process_state.dart';
import 'package:newarch/core/models/view_states/view_state.dart';

class DataState<T> extends ViewState {
  final T? data;
  @override
  final ProcessState status;
  @override
  final String? errorMessage;
  final bool isSearching;
  final TextEditingController? searchController;
  final bool Function(DataState<T> state)? hasDataOverride;

  DataState._({
    this.data,
    required this.status,
    this.errorMessage,
    required this.isSearching,
    this.searchController,
    this.hasDataOverride,
  });

  factory DataState.initial({
    bool hasSearch = false,
    bool Function(DataState<T> state)? hasDataOverride,
  }) {
    return DataState._(
      status: ProcessState.loading,
      isSearching: false,
      searchController: hasSearch ? TextEditingController() : null,
      hasDataOverride: hasDataOverride,
    );
  }

  @override
  bool get hasData => hasDataOverride?.call(this) ?? (data != null && status == ProcessState.success);

  @override
  bool get isEmpty => data == null && status == ProcessState.success;

  bool get hasSearch => searchController != null;

  String? get currentSearch => hasSearch && searchController!.text.trim().isNotEmpty ? searchController!.text.trim() : null;

  DataState<T> copyWith({
    T? data,
    ProcessState? status,
    String? errorMessage,
    bool? isSearching,
    TextEditingController? searchController,
    bool Function(DataState<T> state)? hasDataOverride,
  }) {
    return DataState._(
      data: data ?? this.data,
      status: status ?? this.status,
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
    status,
    errorMessage,
    isSearching,
  ];
}

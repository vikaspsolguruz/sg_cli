import 'package:flutter/material.dart';
import 'package:newarch/core/enums/process_state.dart';
import 'package:newarch/core/models/filter_model.dart';
import 'package:newarch/core/models/view_states/view_state.dart';

class DataStateWithFilter<T, F extends FilterModel> extends ViewState {
  final T? data;
  final F filter;
  @override
  final ProcessState status;
  @override
  final String? errorMessage;
  final bool isSearching;
  final TextEditingController? searchController;
  final bool Function(DataStateWithFilter<T, F> state)? hasDataOverride;

  DataStateWithFilter._({
    this.data,
    required this.filter,
    required this.status,
    this.errorMessage,
    required this.isSearching,
    this.searchController,
    this.hasDataOverride,
  });

  factory DataStateWithFilter.initial({
    required F Function() createInitialFilter,
    bool hasSearch = false,
    bool Function(DataStateWithFilter<T, F> state)? hasDataOverride,
  }) {
    return DataStateWithFilter._(
      filter: createInitialFilter(),
      status: ProcessState.loading,
      isSearching: false,
      searchController: hasSearch ? TextEditingController() : null,
      hasDataOverride: hasDataOverride,
    );
  }

  DataStateWithFilter.loading({
    T? currentData,
    required this.filter,
    bool hasSearch = false,
    TextEditingController? existingController,
    this.hasDataOverride,
  }) : data = currentData,
       status = ProcessState.loading,
       errorMessage = null,
       isSearching = false,
       searchController = existingController ?? (hasSearch ? TextEditingController() : null);

  DataStateWithFilter.success(
    this.data, {
    required this.filter,
    this.searchController,
    this.hasDataOverride,
  }) : status = ProcessState.success,
       errorMessage = null,
       isSearching = false;

  DataStateWithFilter.error({
    required String error,
    T? currentData,
    required this.filter,
    this.searchController,
    this.hasDataOverride,
  }) : data = currentData,
       status = ProcessState.error,
       errorMessage = error,
       isSearching = false;

  @override
  bool get hasData => hasDataOverride?.call(this) ?? (data != null && status == ProcessState.success);

  @override
  bool get isEmpty => data == null && status == ProcessState.success;

  bool get hasSearch => searchController != null;

  String? get currentSearch => hasSearch && searchController!.text.trim().isNotEmpty ? searchController!.text.trim() : null;

  DataStateWithFilter<T, F> copyWith({
    T? data,
    F? filter,
    ProcessState? status,
    String? errorMessage,
    bool? isSearching,
    TextEditingController? searchController,
    bool Function(DataStateWithFilter<T, F> state)? hasDataOverride,
  }) {
    return DataStateWithFilter._(
      data: data ?? this.data,
      filter: filter ?? this.filter,
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
  List<Object?> get props => [data, filter, status, errorMessage, isSearching];
}

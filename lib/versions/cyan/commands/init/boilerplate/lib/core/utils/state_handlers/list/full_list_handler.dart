import 'package:newarch/core/enums/process_state.dart';
import 'package:newarch/core/models/filter_model.dart';
import 'package:newarch/core/models/pagination_model.dart';
import 'package:newarch/core/models/response_data_model.dart';
import 'package:newarch/core/models/view_states/list_state_with_filter.dart';
import 'package:newarch/core/utils/bloc/base_bloc.dart';

/// 🔥 FULL LIST HANDLER - List with all features (pagination, search, filter)
class FullListHandler<T, F extends FilterModel> {
  FullListHandler({
    required this.bloc,
    required this.getViewState,
    required this.updateViewState,
    required this.repositoryCall,
    required this.loadMoreEvent,
  });

  final BaseBloc bloc;
  final ListStateWithFilter<T, F> Function() getViewState;
  final void Function(ListStateWithFilter<T, F> newViewState) updateViewState;
  final Future<ResponseData<PaginationData<List<T>>>> Function() repositoryCall;
  final dynamic Function() loadMoreEvent;

  Future<void> load({bool isRefresh = false, bool isSilent = false}) async {
    if (bloc.isClosed) return;

    // backup used if using silentRefresh
    final backedUpState = getViewState();

    if (isRefresh) backedUpState.searchController?.clear();

    updateViewState(
      backedUpState.copyWith(
        status: isSilent ? null : ProcessState.loading,
        paginationData: isRefresh ? PaginationData.initial(limit: isSilent ? backedUpState.items.length : backedUpState.paginationData?.limit) : null,
        isLoadingMore: false,
        items: const [],
      ),
    );

    final response = await repositoryCall();

    if (bloc.isClosed) return;

    if (response.hasError) {
      updateViewState(
        getViewState().copyWith(
          status: ProcessState.error,
          items: const [],
          errorMessage: response.message,
        ),
      );

      return;
    }

    final paginationData = response.data!;
    final newItems = paginationData.list!;
    paginationData.clearData();

    updateViewState(
      getViewState().copyWith(
        status: ProcessState.success,
        items: newItems,
        isLoadingMore: false,
        paginationData: paginationData.copyWith(limit: isSilent ? backedUpState.paginationData?.limit : null),
      ),
    );
  }

  Future<void> loadMore() async {
    if (bloc.isClosed || !getViewState().canLoadMore) return;

    updateViewState(getViewState().copyWith(isLoadingMore: true));

    final response = await repositoryCall();

    if (bloc.isClosed) return;

    if (response.hasError) {
      Future.delayed(const Duration(seconds: 1), () => bloc.add(loadMoreEvent()));
      return;
    }

    final paginationData = response.data!;
    final newItems = [...getViewState().items, ...?response.data?.list];
    paginationData.clearData();

    updateViewState(
      getViewState().copyWith(
        status: ProcessState.success,
        isLoadingMore: false,
        items: newItems,
        paginationData: paginationData,
      ),
    );
  }

  Future<void> refresh() async {
    if (bloc.isClosed) return;

    await load(isRefresh: true);
  }

  Future<void> silentRefresh() async {
    if (bloc.isClosed) return;

    await load(isRefresh: true, isSilent: true);
  }

  Future<void> updateFilter(F newFilter) async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(currentState.copyWith(filter: newFilter));
    await load();
  }

  Future<void> clearFilters() async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(currentState.copyWith(filter: currentState.filter.clear() as F));
    await load();
  }

  Future<void> search() async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    final query = currentState.searchController?.text ?? '';

    updateViewState(
      currentState.copyWith(
        status: ProcessState.loading,
        paginationData: PaginationData.initial(search: query, limit: currentState.paginationData?.limit),
      ),
    );

    await load();
  }
}

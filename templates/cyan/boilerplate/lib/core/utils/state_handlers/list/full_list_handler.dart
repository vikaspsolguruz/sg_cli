import 'package:newarch/core/models/filter_model.dart';
import 'package:newarch/core/models/pagination_model.dart';
import 'package:newarch/core/models/response_data_model.dart';
import 'package:newarch/core/models/view_states/list_state_with_filter.dart';
import 'package:newarch/core/utils/bloc/base_bloc.dart';
import 'package:newarch/core/utils/extensions.dart';

/// 🔥 FULL LIST HANDLER - List with all features (pagination, search, filter)
class FullListHandler<T, F extends FilterModel> {
  FullListHandler({
    required this.bloc,
    required this.getViewState,
    required this.updateViewState,
    required this.repositoryCall,
    this.onLoadMoreRetry,
  });

  final BaseBloc bloc;
  final ListStateWithFilter<T, F> Function() getViewState;
  final void Function(ListStateWithFilter<T, F> newViewState) updateViewState;
  final Future<ResponseData<PaginationData<List<T>>>> Function() repositoryCall;
  final void Function()? onLoadMoreRetry;

  Future<void> load({bool isRefresh = false}) async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(
      ListStateWithFilter<T, F>.loading(
        currentItems: isRefresh ? null : currentState.items,
        filter: currentState.filter,
        existingController: currentState.searchController,
        paginationData: currentState.paginationData,
      ),
    );

    final response = await repositoryCall();

    if (bloc.isClosed) return;

    if (response.hasError) {
      updateViewState(
        ListStateWithFilter<T, F>.error(
          error: response.message!,
          currentItems: currentState.items,
          filter: currentState.filter,
          currentPagination: currentState.paginationData,
          searchController: currentState.searchController,
        ),
      );
      return;
    }

    final paginationData = response.data!;
    final newItems = paginationData.list!;
    paginationData.clearData();

    updateViewState(currentState.withNewItems(newItems: newItems, newPagination: paginationData, isLoadMore: false));
  }

  Future<void> loadMore() async {
    final currentState = getViewState();
    if (bloc.isClosed || !currentState.canLoadMore) return;

    updateViewState(currentState.startLoadingMore());

    final response = await repositoryCall();

    if (bloc.isClosed) return;

    if (response.hasError) {
      if (onLoadMoreRetry != null) {
        Future.delayed(const Duration(seconds: 1), onLoadMoreRetry!);
        return;
      }

      updateViewState(
        ListStateWithFilter<T, F>.error(
          error: response.message!,
          currentItems: currentState.items,
          filter: currentState.filter,
          currentPagination: currentState.paginationData,
          searchController: currentState.searchController,
        ),
      );
      return;
    }

    final paginationData = response.data!;
    final newItems = paginationData.list!;
    paginationData.clearData();

    updateViewState(currentState.withNewItems(newItems: newItems, newPagination: paginationData, isLoadMore: true));
  }

  Future<void> refresh() async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(
      ListStateWithFilter<T, F>.initial(
        createInitialFilter: () => currentState.filter,
        hasSearch: currentState.hasSearch,
      ),
    );

    await load(isRefresh: true);
  }

  Future<void> updateFilter(F newFilter) async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(currentState.withUpdatedFilter(newFilter));
    await load();
  }

  Future<void> clearFilters() async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(currentState.withClearedFilters());
    await load();
  }
}

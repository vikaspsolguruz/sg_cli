import 'package:newarch/core/models/pagination_model.dart';
import 'package:newarch/core/models/response_data_model.dart';
import 'package:newarch/core/models/view_states/list_state.dart';
import 'package:newarch/core/utils/bloc/base_bloc.dart';
import 'package:newarch/core/utils/extensions.dart';

/// 🔥 PAGINATED LIST HANDLER - List with pagination & search (no filter)
class PaginatedListHandler<T> {
  PaginatedListHandler({
    required this.bloc,
    required this.getViewState,
    required this.updateViewState,
    required this.repositoryCall,
    this.onLoadMoreRetry,
  });

  final BaseBloc bloc;
  final ListState<T> Function() getViewState;
  final void Function(ListState<T> newViewState) updateViewState;
  final Future<ResponseData<PaginationData<List<T>>>> Function({required PaginationData paginationData, String? searchQuery}) repositoryCall;
  final void Function()? onLoadMoreRetry;

  Future<void> load({bool isRefresh = false}) async {
    if (bloc.isClosed) return;
    final currentState = getViewState();

    updateViewState(
      ListState<T>.loading(
        currentItems: isRefresh ? null : currentState.items,
        existingController: currentState.searchController,
      ),
    );

    final response = await repositoryCall(
      paginationData: currentState.paginationData!,
      searchQuery: currentState.currentSearch,
    );

    if (bloc.isClosed) return;

    if (response.hasError) {
      updateViewState(
        ListState<T>.error(
          error: response.message!,
          currentItems: currentState.items,
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

    final response = await repositoryCall(
      paginationData: currentState.paginationData!,
      searchQuery: currentState.currentSearch,
    );

    if (bloc.isClosed) return;

    if (response.hasError) {
      if (onLoadMoreRetry != null) {
        Future.delayed(const Duration(seconds: 1), onLoadMoreRetry!);
        return;
      }

      updateViewState(
        ListState<T>.error(
          error: response.message!,
          currentItems: currentState.items,
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

    updateViewState(ListState<T>.initial(hasSearch: currentState.hasSearch));
    await load(isRefresh: true);
  }
}

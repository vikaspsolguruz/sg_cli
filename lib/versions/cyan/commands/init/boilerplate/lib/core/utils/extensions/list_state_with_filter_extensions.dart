part of '../extensions.dart';

extension ListStateWithFilterExtensions<T, F extends FilterModel> on ListStateWithFilter<T, F> {
  ListStateWithFilter<T, F> withNewItems({
    required List<T> newItems,
    PaginationData? newPagination,
    required bool isLoadMore,
  }) {
    return ListStateWithFilter.success(
      items: isLoadMore ? [...items, ...newItems] : newItems,
      filter: filter,
      paginationData: newPagination ?? paginationData,
      isSearching: isSearching,
      searchController: searchController,
    );
  }

  ListStateWithFilter<T, F> withUpdatedFilter(F newFilter) {
    return ListStateWithFilter.loading(
      currentItems: const [],
      filter: newFilter,
      isPaginated: isPaginated,
      existingController: searchController,
      paginationData: paginationData,
    );
  }

  ListStateWithFilter<T, F> withClearedFilters() {
    return withUpdatedFilter(filter.clear() as F);
  }

  ListStateWithFilter<T, F> startLoadingMore() {
    if (!isPaginated || paginationData == null) return this;

    return ListStateWithFilter.loadingMore(
      items: items,
      filter: filter,
      paginationData: paginationData!.copyWith(
        offset: paginationData!.offset ?? 0,
      ),
      isSearching: isSearching,
      searchController: searchController,
    );
  }
}

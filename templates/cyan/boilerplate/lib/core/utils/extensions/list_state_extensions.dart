part of '../extensions.dart';

extension ListStateExtensions<T> on ListState<T> {
  ListState<T> withNewItems({
    required List<T> newItems,
    PaginationData? newPagination,
    required bool isLoadMore,
  }) {
    return ListState.success(
      items: isLoadMore ? [...items, ...newItems] : newItems,
      paginationData: newPagination ?? paginationData,
      isSearching: isSearching,
      searchController: searchController,
    );
  }

  ListState<T> withRemovedItem(T item) {
    return copyWith(
      items: items.where((i) => i != item).toList(),
    );
  }

  ListState<T> withUpdatedItem({
    required T oldItem,
    required T newItem,
  }) {
    final index = items.indexOf(oldItem);
    if (index == -1) return this;

    final updatedItems = [...items];
    updatedItems[index] = newItem;

    return copyWith(items: updatedItems);
  }

  ListState<T> startLoadingMore() {
    if (!isPaginated || paginationData == null) return this;

    return ListState.loadingMore(
      items: items,
      paginationData: paginationData!.copyWith(
        offset: paginationData!.offset ?? 0,
      ),
      isSearching: isSearching,
      searchController: searchController,
    );
  }
}

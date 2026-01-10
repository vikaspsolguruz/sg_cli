part of 'list.dart';

/// Required generics < Bloc, State, ListItemModel >
///
/// SliverList widget for ListState with pagination support - use in CustomScrollView
class SliverListStateWidget<B extends StateStreamable<S>, S, T> extends StatelessWidget {
  const SliverListStateWidget({
    super.key,
    required this.listStateSelector,
    required this.itemBuilder,
    this.onLoadMore,
    this.onRetryError,
    this.onRetryEmpty,
    this.localSearch,
    this.emptyTitle,
    this.emptySubtitle,
    this.svgPath,
    this.separatorBuilder,
    this.loaderView,
    this.errorView,
    this.emptyView,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.isExpanded = false,
    required this.padding,
  });

  final ListState<T> Function(S state) listStateSelector;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final void Function(S state)? onLoadMore;
  final VoidCallback? onRetryError;
  final VoidCallback? onRetryEmpty;

  final bool Function(T item, String searchText)? localSearch;

  final String Function(B bloc, List<T> data)? emptyTitle;
  final String Function(B bloc, List<T> data)? emptySubtitle;
  final String Function(B bloc, List<T> data)? svgPath;
  final Widget Function(BuildContext, int)? separatorBuilder;

  final Widget? loaderView;
  final Widget? errorView;
  final Widget? emptyView;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final bool isExpanded;
  final EdgeInsetsGeometry padding;

  /// Helper method to get filtered items based on local filtering
  List<T> _getFilteredItems(ListState<T> listState) {
    // Only apply local filtering if:
    // 1. localSearch function is provided
    // 2. Pagination is disabled (no paginationData)
    // 3. Search text exists
    // 4. Items exist to filter
    final searchText = listState.currentSearch ?? '';

    if (localSearch == null || listState.isPaginated || listState.items.isEmpty || searchText.trim().isEmpty) {
      return listState.items;
    }

    // Apply local filtering
    return listState.items.where((item) {
      try {
        return localSearch!(item, searchText);
      } catch (e, s) {
        // If filter function throws error, include the item
        xErrorPrint(e, stackTrace: s);
        return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, ListState<T>>(
      selector: listStateSelector,
      builder: (context, listState) {
        // Apply local filtering if applicable
        final filteredItems = _getFilteredItems(listState);
        final hasFilteredData = filteredItems.isNotEmpty;

        return SliverAnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (listState.status) {
            ProcessState.loading => isExpanded ? SliverFillRemaining(child: loaderView ?? const CommonLoader()) : SliverToBoxAdapter(child: loaderView ?? const CommonLoader()),

            ProcessState.error =>
            isExpanded
                ? SliverFillRemaining(
                    child:
                        errorView ??
                        ErrorView(
                          title: listState.errorMessage ?? AppStrings.somethingWentWrong,
                          onRetry: onRetryError,
                          svgPath: svgPath?.call(context.read<B>(), listState.items),
                        ),
                  )
                : SliverToBoxAdapter(
                    child:
                        errorView ??
                        ErrorView(
                          title: listState.errorMessage ?? AppStrings.somethingWentWrong,
                          onRetry: onRetryError,
                          svgPath: svgPath?.call(context.read<B>(), listState.items),
                        ),
                    ),

            ProcessState.success =>
            !hasFilteredData
                ? isExpanded
                      ? SliverFillRemaining(
                          child:
                              emptyView ??
                              EmptyView(
                                title: emptyTitle?.call(context.read<B>(), filteredItems) ?? 'No items found',
                                subtitle: emptySubtitle?.call(context.read<B>(), filteredItems),
                                svgPath: svgPath?.call(context.read<B>(), filteredItems),
                                onRetry: onRetryEmpty,
                              ),
                        )
                      : SliverToBoxAdapter(
                          child:
                              emptyView ??
                              EmptyView(
                                title: emptyTitle?.call(context.read<B>(), filteredItems) ?? 'No items found',
                                subtitle: emptySubtitle?.call(context.read<B>(), filteredItems),
                                svgPath: svgPath?.call(context.read<B>(), filteredItems),
                                onRetry: onRetryEmpty,
                              ),
                        )
                : separatorBuilder != null
                ? _SliverListWithSeparators<T>(
                    items: filteredItems,
                    listState: listState,
                    itemBuilder: itemBuilder,
                    separatorBuilder: separatorBuilder!,
                    onLoadMore: () => onLoadMore?.call(context.read<B>().state),
                    addAutomaticKeepAlives: addAutomaticKeepAlives,
                    addRepaintBoundaries: addRepaintBoundaries,
                    addSemanticIndexes: addSemanticIndexes,
                    padding: padding,
                  )
                  : _SliverListContent<T>(
                      items: filteredItems,
                      listState: listState,
                      itemBuilder: itemBuilder,
                      onLoadMore: () => onLoadMore?.call(context.read<B>().state),
                      addAutomaticKeepAlives: addAutomaticKeepAlives,
                      addRepaintBoundaries: addRepaintBoundaries,
                      addSemanticIndexes: addSemanticIndexes,
                      padding: padding,
                    ),
          },
        );
      },
    );
  }
}

class _SliverListContent<T> extends StatelessWidget {
  const _SliverListContent({
    required this.items,
    required this.listState,
    required this.itemBuilder,
    this.onLoadMore,
    required this.addAutomaticKeepAlives,
    required this.addRepaintBoundaries,
    required this.addSemanticIndexes,
    required this.padding,
  });

  final List<T> items; // Filtered items passed from parent
  final ListState<T> listState;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final VoidCallback? onLoadMore;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final itemCount = items.length + (listState.canLoadMore ? 1 : 0);

    return SliverPadding(
      padding: padding,
      sliver: SliverList.builder(
        itemCount: itemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        itemBuilder: (context, index) {
          // Loading more indicator
          if (index == items.length) {
            return CommonLoader(
              onBuild: () => onLoadMore?.call(),
            );
          }

          final item = items[index];
          return itemBuilder(context, item, index);
        },
      ),
    );
  }
}

class _SliverListWithSeparators<T> extends StatelessWidget {
  const _SliverListWithSeparators({
    required this.items,
    required this.listState,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.onLoadMore,
    required this.addAutomaticKeepAlives,
    required this.addRepaintBoundaries,
    required this.addSemanticIndexes,
    required this.padding,
  });

  final List<T> items;
  final ListState<T> listState;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final VoidCallback? onLoadMore;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final baseItemCount = items.length;
    final itemCount = baseItemCount + (listState.canLoadMore ? 1 : 0);

    return SliverPadding(
      padding: padding,
      sliver: SliverList.separated(
        itemCount: itemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        itemBuilder: (context, index) {
          // Loading more indicator
          if (index == items.length) return CommonLoader(onBuild: () => onLoadMore?.call());

          final item = items[index];
          return itemBuilder(context, item, index);
        },
        separatorBuilder: (context, index) {
          if (index < items.length - 1) {
            return separatorBuilder(context, index);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

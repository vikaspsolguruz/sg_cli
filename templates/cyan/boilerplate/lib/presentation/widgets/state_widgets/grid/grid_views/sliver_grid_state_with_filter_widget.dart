part of '../grid.dart';

/// Enhanced SliverGrid widget for ListStateWithFilter
/// Use this inside a CustomScrollView for advanced scrolling effects
class SliverGridStateWithFilterWidget<B extends StateStreamable<S>, S, T, F extends FilterModel> extends StatelessWidget {
  const SliverGridStateWithFilterWidget({
    super.key,
    required this.stateSelector,
    required this.itemBuilder,
    required this.gridDelegate,
    this.onRetryError,
    this.onRetryEmpty,
    this.onLoadMore,
    this.emptyTitle,
    this.emptySubtitle,
    this.svgPath,
    this.loaderView,
    this.errorView,
    this.emptyView,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.isExpanded = false,
    required this.padding,
  });

  final ListStateWithFilter<T, F> Function(S state) stateSelector;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  final SliverGridDelegate gridDelegate;

  final VoidCallback? onRetryError;
  final VoidCallback? onRetryEmpty;
  final void Function(S state)? onLoadMore;

  final String Function(B bloc, List<T> data)? emptyTitle;
  final String? Function(B bloc, List<T> data)? emptySubtitle;
  final String? Function(B bloc, List<T>? data)? svgPath;

  final Widget? loaderView;
  final Widget? errorView;
  final Widget? emptyView;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  final bool isExpanded;

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, ListStateWithFilter<T, F>>(
      selector: stateSelector,
      builder: (context, listState) {
        return SliverAnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (listState.status) {
            // 1. Loading state - show loader
            ProcessState.loading =>
              isExpanded
                  ? SliverFillRemaining(
                      child: loaderView ?? const LoaderWidget(),
                    )
                  : SliverToBoxAdapter(
                      child: loaderView ?? const LoaderWidget(),
                    ),
            // 2. Error state - show error view
            ProcessState.error =>
              isExpanded
                  ? SliverFillRemaining(
                      child:
                          errorView ??
                          ErrorView(
                            title: listState.errorMessage ?? 'Something went wrong',
                            onRetry: onRetryError,
                            svgPath: svgPath?.call(context.read<B>(), null),
                          ),
                    )
                  : SliverToBoxAdapter(
                      child:
                          errorView ??
                          ErrorView(
                            title: listState.errorMessage ?? 'Something went wrong',
                            onRetry: onRetryError,
                            svgPath: svgPath?.call(context.read<B>(), null),
                          ),
                    ),
            // 3. Success state - check if no data first, then show content
            ProcessState.success =>
              !listState.hasData
                  ? isExpanded
                        ? SliverFillRemaining(
                            child:
                                emptyView ??
                                EmptyView(
                                  title: emptyTitle?.call(context.read<B>(), listState.items) ?? 'No items found',
                                  subtitle: emptySubtitle?.call(context.read<B>(), listState.items),
                                  svgPath: svgPath?.call(context.read<B>(), listState.items),
                                  onRetry: onRetryEmpty,
                                ),
                          )
                        : SliverToBoxAdapter(
                            child:
                                emptyView ??
                                EmptyView(
                                  title: emptyTitle?.call(context.read<B>(), listState.items) ?? 'No items found',
                                  subtitle: emptySubtitle?.call(context.read<B>(), listState.items),
                                  svgPath: svgPath?.call(context.read<B>(), listState.items),
                                  onRetry: onRetryEmpty,
                                ),
                          )
                  : SliverPadding(
                      padding: padding,
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          // Grid content
                          _SliverGridFilterContent<T, F>(
                            listState: listState,
                            itemBuilder: itemBuilder,
                            gridDelegate: gridDelegate,
                            addAutomaticKeepAlives: addAutomaticKeepAlives,
                            addRepaintBoundaries: addRepaintBoundaries,
                            addSemanticIndexes: addSemanticIndexes,
                            onLoadMore: () => onLoadMore?.call(context.read<B>().state),
                          ),

                          if (listState.canLoadMore) const SliverToBoxAdapter(child: LoaderWidget()),
                        ],
                      ),
                    ),
          },
        );
      },
    );
  }
}

/// Internal widget for grid content with filter support
class _SliverGridFilterContent<T, F extends FilterModel> extends StatelessWidget {
  const _SliverGridFilterContent({
    required this.listState,
    required this.itemBuilder,
    required this.gridDelegate,
    required this.addAutomaticKeepAlives,
    required this.addRepaintBoundaries,
    required this.addSemanticIndexes,
    required this.onLoadMore,
  });

  final ListStateWithFilter<T, F> listState;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final SliverGridDelegate gridDelegate;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: gridDelegate,
      itemCount: listState.items.length,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      itemBuilder: (context, index) {
        if (index == listState.items.length - 1 && listState.canLoadMore && !listState.isLoadingMore) {
          WidgetsBinding.instance.scheduleFrameCallback((timeStamp) => onLoadMore());
        }
        return itemBuilder(context, listState.items[index], index);
      },
    );
  }
}

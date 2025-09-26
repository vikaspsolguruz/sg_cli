part of '../grid.dart';

/// SliverGrid widget for ListState with pagination support - use in CustomScrollView
class SliverGridStateWidget<B extends StateStreamable<S>, S, T> extends StatelessWidget {
  const SliverGridStateWidget({
    super.key,
    required this.listStateSelector,
    required this.itemBuilder,
    required this.gridDelegate,
    this.onLoadMore,
    this.onRetryError,
    this.onRetryEmpty,
    this.emptyTitle,
    this.emptySubtitle,
    this.svgPath,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.isExpanded = false,
    required this.padding,
  });

  final ListState<T> Function(S state) listStateSelector;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final SliverGridDelegate gridDelegate;
  final void Function(S state)? onLoadMore;
  final VoidCallback? onRetryError;
  final VoidCallback? onRetryEmpty;
  final String Function(B bloc, List<T> data)? emptyTitle;
  final String Function(B bloc, List<T> data)? emptySubtitle;
  final String Function(B bloc, List<T> data)? svgPath;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final bool isExpanded;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, ListState<T>>(
      selector: listStateSelector,
      builder: (context, listState) {
        return switch (listState.status) {
          // 1. Loading state - show loader
          ProcessState.loading => isExpanded ? const SliverFillRemaining(child: LoaderWidget()) : const SliverToBoxAdapter(child: LoaderWidget()),

          // 2. Error state - show error view
          ProcessState.error =>
            isExpanded
                ? SliverFillRemaining(
                    child: ErrorView(
                      title: listState.errorMessage ?? 'Something went wrong',
                      onRetry: onRetryError,
                    ),
                  )
                : SliverToBoxAdapter(
                    child: ErrorView(
                      title: listState.errorMessage ?? 'Something went wrong',
                      onRetry: onRetryError,
                    ),
                  ),

          // 3. Success state - check if no data first, then show content
          ProcessState.success =>
            !listState.hasData
                ? isExpanded
                      ? SliverFillRemaining(
                          child: EmptyView(
                            title: emptyTitle?.call(context.read<B>(), listState.items) ?? 'No items found',
                            subtitle: emptySubtitle?.call(context.read<B>(), listState.items),
                            svgPath: svgPath?.call(context.read<B>(), listState.items),
                            onRetry: onRetryEmpty,
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: EmptyView(
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
                        _SliverGridContent<T>(
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
        };
      },
    );
  }
}

class _SliverGridContent<T> extends StatelessWidget {
  const _SliverGridContent({
    required this.listState,
    required this.itemBuilder,
    required this.gridDelegate,
    required this.addAutomaticKeepAlives,
    required this.addRepaintBoundaries,
    required this.addSemanticIndexes,
    required this.onLoadMore,
  });

  final ListState<T> listState;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final SliverGridDelegate gridDelegate;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: listState.items.length,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      gridDelegate: gridDelegate,
      itemBuilder: (context, index) {
        if (index == listState.items.length - 1 && listState.canLoadMore && !listState.isLoadingMore) {
          WidgetsBinding.instance.scheduleFrameCallback((timeStamp) => onLoadMore());
        }
        return itemBuilder(context, listState.items[index], index);
      },
    );
  }
}

part of 'list.dart';

class SliverListStateWithFilterWidget<B extends StateStreamable<S>, S, T, F extends FilterModel> extends StatelessWidget {
  const SliverListStateWithFilterWidget({
    super.key,
    required this.stateSelector,
    required this.itemBuilder,
    this.onRetryError,
    this.onRetryEmpty,
    this.onLoadMore,
    this.separatorBuilder,
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
    this.padding = EdgeInsets.zero,
  });

  final ListStateWithFilter<T, F> Function(S state) stateSelector;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  final Widget Function(BuildContext, int)? separatorBuilder;

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
                            title: listState.errorMessage ?? AppStrings.somethingWentWrong,
                            onRetry: onRetryError,
                            svgPath: svgPath?.call(context.read<B>(), null),
                          ),
                    )
                  : SliverToBoxAdapter(
                      child:
                          errorView ??
                          ErrorView(
                            title: listState.errorMessage ?? AppStrings.somethingWentWrong,
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
                  : separatorBuilder != null
                  ? _SliverListFilterWithSeparators<T, F>(
                      listState: listState,
                      itemBuilder: itemBuilder,
                      separatorBuilder: separatorBuilder!,
                      onLoadMore: () => onLoadMore?.call(context.read<B>().state),
                      addAutomaticKeepAlives: addAutomaticKeepAlives,
                      addRepaintBoundaries: addRepaintBoundaries,
                      addSemanticIndexes: addSemanticIndexes,
                      padding: padding,
                    )
                  : _SliverListFilterContent<T, F>(
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

class _SliverListFilterContent<T, F extends FilterModel> extends StatelessWidget {
  const _SliverListFilterContent({
    required this.listState,
    required this.itemBuilder,
    this.onLoadMore,
    required this.addAutomaticKeepAlives,
    required this.addRepaintBoundaries,
    required this.addSemanticIndexes,
    required this.padding,
  });

  final ListStateWithFilter<T, F> listState;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final VoidCallback? onLoadMore;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final itemCount = listState.items.length + (listState.canLoadMore ? 1 : 0);

    return SliverPadding(
      padding: padding,
      sliver: SliverList.builder(
        itemCount: itemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        itemBuilder: (context, index) {
          // Loading more indicator using LoaderWidget with onBuild for pagination
          if (index == listState.items.length) {
            return LoaderWidget(onBuild: () => onLoadMore?.call());
          }

          final item = listState.items[index];
          return itemBuilder(context, item, index);
        },
      ),
    );
  }
}

class _SliverListFilterWithSeparators<T, F extends FilterModel> extends StatelessWidget {
  const _SliverListFilterWithSeparators({
    required this.listState,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.onLoadMore,
    required this.addAutomaticKeepAlives,
    required this.addRepaintBoundaries,
    required this.addSemanticIndexes,
    required this.padding,
  });

  final ListStateWithFilter<T, F> listState;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext, int) separatorBuilder;
  final VoidCallback? onLoadMore;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final baseItemCount = listState.items.length;
    final itemCount = baseItemCount + (listState.canLoadMore ? 1 : 0);

    return SliverPadding(
      padding: padding,
      sliver: SliverList.separated(
        itemCount: itemCount,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        itemBuilder: (context, index) {
          if (index == listState.items.length) {
            return LoaderWidget(
              onBuild: () => onLoadMore?.call(),
            );
          }

          final item = listState.items[index];
          return itemBuilder(context, item, index);
        },
        separatorBuilder: (context, index) {
          if (index < listState.items.length - 1) {
            return separatorBuilder(context, index);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

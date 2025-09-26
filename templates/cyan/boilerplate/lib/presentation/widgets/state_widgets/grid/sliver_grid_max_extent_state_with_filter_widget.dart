part of 'grid.dart';

/// Helper widget to easily create SliverGrid with max cross axis extent for filter state
class SliverGridMaxExtentStateWithFilterWidget<B extends StateStreamable<S>, S, T, F extends FilterModel> extends StatelessWidget {
  const SliverGridMaxExtentStateWithFilterWidget({
    super.key,
    this.isExpanded = false,
    required this.stateSelector,
    required this.itemBuilder,
    required this.maxCrossAxisExtent,
    this.onRetryError,
    this.onRetryEmpty,
    this.onLoadMore,
    this.emptyTitle,
    this.emptySubtitle,
    this.svgPath,
    this.loaderView,
    this.errorView,
    this.emptyView,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.padding = EdgeInsets.zero,
  });

  final bool isExpanded;

  final ListStateWithFilter<T, F> Function(S state) stateSelector;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  final double maxCrossAxisExtent;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;

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

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SliverGridStateWithFilterWidget<B, S, T, F>(
      isExpanded: isExpanded,
      stateSelector: stateSelector,
      itemBuilder: itemBuilder,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      onRetryError: onRetryError,
      onRetryEmpty: onRetryEmpty,
      onLoadMore: onLoadMore,
      emptyTitle: emptyTitle,
      emptySubtitle: emptySubtitle,
      svgPath: svgPath,
      loaderView: loaderView,
      errorView: errorView,
      emptyView: emptyView,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      padding: padding,
    );
  }
}

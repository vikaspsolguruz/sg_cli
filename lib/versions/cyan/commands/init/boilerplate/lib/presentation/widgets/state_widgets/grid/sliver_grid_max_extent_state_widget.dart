part of 'grid.dart';

/// Helper widget to easily create SliverGrid with max cross axis extent
class SliverGridMaxExtentStateWidget<B extends StateStreamable<S>, S, T> extends StatelessWidget {
  const SliverGridMaxExtentStateWidget({
    super.key,
    required this.listStateSelector,
    required this.itemBuilder,
    required this.maxCrossAxisExtent,
    this.onLoadMore,
    this.onRetryError,
    this.onRetryEmpty,
    this.emptyTitle,
    this.emptySubtitle,
    this.svgPath,
    this.loaderView,
    this.errorView,
    this.emptyView,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.isExpanded = false,
    this.padding = EdgeInsets.zero,
  });

  final ListState<T> Function(S state) listStateSelector;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double maxCrossAxisExtent;
  final void Function(S state)? onLoadMore;
  final VoidCallback? onRetryError;
  final VoidCallback? onRetryEmpty;
  final String Function(B bloc, List<T> data)? emptyTitle;
  final String Function(B bloc, List<T> data)? emptySubtitle;
  final String Function(B bloc, List<T> data)? svgPath;
  final Widget? loaderView;
  final Widget? errorView;
  final Widget? emptyView;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final bool isExpanded;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SliverGridStateWidget<B, S, T>(
      listStateSelector: listStateSelector,
      itemBuilder: itemBuilder,
      onLoadMore: onLoadMore,
      onRetryError: onRetryError,
      onRetryEmpty: onRetryEmpty,
      emptyTitle: emptyTitle,
      emptySubtitle: emptySubtitle,
      svgPath: svgPath,
      loaderView: loaderView,
      errorView: errorView,
      emptyView: emptyView,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      isExpanded: isExpanded,
      padding: padding,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
    );
  }
}

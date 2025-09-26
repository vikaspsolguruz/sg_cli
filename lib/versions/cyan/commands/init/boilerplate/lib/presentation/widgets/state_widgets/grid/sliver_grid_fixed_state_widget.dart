part of 'grid.dart';

/// Helper widget to easily create SliverGrid with fixed cross axis count
class SliverGridFixedStateWidget<B extends StateStreamable<S>, S, T> extends StatelessWidget {
  const SliverGridFixedStateWidget({
    super.key,
    required this.listStateSelector,
    required this.itemBuilder,
    required this.crossAxisCount,
    this.onLoadMore,
    this.onRetryError,
    this.onRetryEmpty,
    this.emptyTitle,
    this.emptySubtitle,
    this.svgPath,
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
  final int crossAxisCount;
  final void Function(S state)? onLoadMore;
  final VoidCallback? onRetryError;
  final VoidCallback? onRetryEmpty;
  final String Function(B bloc, List<T> data)? emptyTitle;
  final String Function(B bloc, List<T> data)? emptySubtitle;
  final String Function(B bloc, List<T> data)? svgPath;
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
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      isExpanded: isExpanded,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
    );
  }
}

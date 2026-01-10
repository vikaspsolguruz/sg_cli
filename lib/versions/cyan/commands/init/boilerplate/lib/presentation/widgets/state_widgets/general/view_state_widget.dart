part of 'general.dart';

/// Universal ViewState widget
/// < Bloc, State, ViewState, Data >
class ViewStateWidget<B extends StateStreamable<S>, S, V extends ViewState, D> extends StatelessWidget {
  const ViewStateWidget({
    super.key,
    required this.viewStateSelector,
    required this.dataSelector,
    required this.child,
    this.onRetryError,
    this.onRetryEmpty,
    this.emptyTitle,
    this.emptySubtitle,
    this.svgPath,
    this.loaderView,
    this.errorView,
    this.emptyView,
  });

  final V Function(S state) viewStateSelector;
  final D Function(S state) dataSelector;
  final Widget Function(D data) child;
  final VoidCallback? onRetryError;
  final VoidCallback? onRetryEmpty;
  final String Function(B bloc, D data)? emptyTitle;
  final String? Function(B bloc, D data)? emptySubtitle;
  final String? Function(B bloc, D? data)? svgPath;
  final Widget? loaderView;
  final Widget? errorView;
  final Widget? emptyView;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, V>(
      selector: viewStateSelector,
      builder: (context, viewState) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: switch (viewState.status) {
            ProcessState.loading => loaderView ?? const CommonLoader(),
            ProcessState.error =>
              errorView ??
                  ErrorView(
                    title: viewState.errorMessage ?? 'Something went wrong',
                    onRetry: onRetryError,
                    svgPath: svgPath?.call(context.read<B>(), null),
                  ),
            ProcessState.success => BlocSelector<B, S, D>(
              selector: dataSelector,
              builder: (context, data) {
                if (viewState.hasData) {
                  return child(data);
                } else {
                  final bloc = context.read<B>();
                  return emptyView ??
                      EmptyView(
                        title: emptyTitle?.call(bloc, data) ?? 'No data found',
                        subtitle: emptySubtitle?.call(bloc, data),
                        svgPath: svgPath?.call(bloc, data),
                        onRetry: onRetryEmpty,
                      );
                }
              },
            ),
          },
        );
      },
    );
  }
}

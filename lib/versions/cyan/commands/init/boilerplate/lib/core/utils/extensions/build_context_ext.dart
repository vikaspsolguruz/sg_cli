part of '../extensions.dart';

extension AppBuildContextExtensions on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;

  EdgeInsets get viewInsects => MediaQuery.of(this).viewInsets;

  EdgeInsets get padding => MediaQuery.of(this).padding;

  double get topPadding => padding.top;

  double get bottomPadding => padding.bottom;

  double get bottomViewInsect => viewInsects.bottom;

  double get leftPadding => padding.left;

  double get rightPadding => padding.right;

  double get heightWithoutAppBarAndVerticalPadding {
    const double appBarHeight = kToolbarHeight;
    final double verticalPadding = topPadding + bottomPadding;
    return height - appBarHeight - verticalPadding;
  }

  double get heightWithoutVerticalPadding {
    final double verticalPadding = topPadding + bottomPadding;
    return height - verticalPadding;
  }

  void pop<T extends Object?>([T? result]) => Navigator.maybePop(this);

  void forcePop<T extends Object?>([T? result]) => Navigator.pop(this);

  bool get canPop => ModalRoute.of(this)?.canPop ?? false;

  ThemeData get theme => Theme.of(this);

  bool get isDarkMode => theme.brightness == Brightness.dark;

  Map<String, dynamic>? get arguments => (ModalRoute.of(this)?.settings.arguments) as Map<String, dynamic>?;
}

extension OnNullableContext on BuildContext? {
  BuildContext get secured => this ?? AppState.appContext;
}

extension ContextToColors on BuildContext {
  AppColors get colors => isDarkMode ? AppColors.dark() : AppColors.light();
}

extension ShowBottomSheet on BuildContext {
  Future<void> showBottomSheet(Widget child) async {
    return showModalBottomSheet(
      context: this,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext context) => child,
    );
  }
}

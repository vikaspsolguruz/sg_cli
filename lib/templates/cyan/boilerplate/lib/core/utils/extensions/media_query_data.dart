part of '../extensions.dart';

extension MediaQueryHeightExcludingVerticalPadding on MediaQueryData {
  double? heightExcludingVerticalPadding() => size.height - padding.top - padding.bottom;
}

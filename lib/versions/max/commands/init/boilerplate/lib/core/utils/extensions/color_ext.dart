part of '../extensions.dart';

extension ColorExt on Color {
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${((a * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
      '${((r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
      '${((g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
      '${((b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}';

  // Todo: Enable on fully deprecation by flutter
  // /// set value 0.0 to 1.0
  // Color withOpacity(num opacity) {
  //   return withAlpha((255.0 * opacity.clamp(0, 1)).round());
  // }
}

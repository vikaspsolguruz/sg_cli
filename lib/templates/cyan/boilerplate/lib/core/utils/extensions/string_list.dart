part of '../extensions.dart';

extension NullableStringListExtension on List<String>? {
  /// Checks if the list is equal to another list ignoring indexes
  bool isEqualTo(List<String>? other) {
    if (this == other) {
      return true;
    }
    if (this == null || other == null) {
      return false;
    }
    return this!.every((element) => other.contains(element)) && other.every((element) => this!.contains(element));
  }
}

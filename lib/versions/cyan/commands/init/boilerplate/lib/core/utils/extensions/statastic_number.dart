extension NumberFormatExtension on int {
  String toFormattedString() {
    if (this <= 1000) {
      return toString();
    } else {
      double value = this / 1000;
      String formatted = value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
      return '${formatted}K+';
    }
  }
}

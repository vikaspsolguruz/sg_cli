
import 'package:max_arch/core/utils/console_print.dart';

String getNameInitials(String name) {
  String initials = name.replaceAll('  ', ' ');
  final splits = name.split(" ");
  if (splits.length > 1) {
    final firstChar = splits[0].split('').firstOrNull ?? "";
    String secondChar = "";
    try {
      secondChar = splits[1].split('').firstOrNull ?? "";
    } catch (e) {
      xErrorPrint(initials);
    }
    initials = "$firstChar$secondChar";
  } else {
    initials = (name.split("").firstOrNull ?? "");
  }
  return initials.toUpperCase();
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

const _allowResponsePrint = true;
const _allowPayloadPrint = true;
const _prettyJson = false;

void xPrint(Object? object, {String? title}) {
  if (kReleaseMode) return;
  log("$object", name: title?.trim() ?? '');
}

void xResponsePrint(Object? response, {String? title}) {
  if (kReleaseMode || !_allowResponsePrint) return;
  if (response is Map || response is List) {
    if (_prettyJson) {
      response = const JsonEncoder.withIndent('  ').convert(response);
    } else {
      response = const JsonEncoder.withIndent('').convert(response).replaceAll('\n', ' ');
    }
  }
  log("$response", name: "Response ${title?.trim() ?? ''}");
}

void xPayloadPrint(Object? response, {String? title}) {
  if (kReleaseMode || !_allowPayloadPrint) return;
  title = title == null ? '' : " ${title.trim()}";
  if (_allowPayloadPrint) {
    if (response is Map || response is List) {
      if (_prettyJson) {
        response = const JsonEncoder.withIndent('  ').convert(response);
      }
      response = const JsonEncoder.withIndent('').convert(response).replaceAll('\n', ' ');
    }
    log("$response", name: "Payload$title");
  }
}

void xJsonPrint(Object? response, {String? title}) {
  if (kReleaseMode || !_allowPayloadPrint) return;
  title = title == null ? 'Json' : title.trim();
  if (_allowPayloadPrint) {
    if (response is Map || response is List) {
      if (_prettyJson) {
        response = const JsonEncoder.withIndent('  ').convert(response);
      }
      response = const JsonEncoder.withIndent('').convert(response).replaceAll('\n', ' ');
    }
    log("$response", name: title);
  }
}

void xTempPrint(Object? object, {String? title}) {
  if (kReleaseMode) return;
  log("$object", name: title ?? "Temp");
}

void xErrorPrint(Object? error, {StackTrace? stackTrace}) {
  if (kReleaseMode) return;
  int codeLines = 0;

  stackTrace ??= StackTrace.current;
  final allLines = stackTrace.toString().trimRight().split('\n');
  final filteredLines = allLines.where((value) => value.contains('package:radon') && !value.contains('console_print.dart')).toList();
  if (filteredLines.isNotEmpty) {
    allLines.clear();
    allLines.addAll(filteredLines);
  }

  for (int i = 0; i < allLines.length; i++) {
    var element = allLines[i];
    element = element.split('      ').last;
    allLines[i] = "        #${i + 1} $element";
  }
  final string = "${allLines.join('\n')}\n";

  codeLines = allLines.length;

  String fakeStackTrace = 'ERROR';
  fakeStackTrace = "$codeLines Stacks: \n$string";

  log(error.toString(), name: 'ERROR', error: fakeStackTrace);
}

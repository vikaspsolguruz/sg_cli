import 'package:flutter/material.dart';

class TextFieldController {
  TextFieldController({
    TextEditingController? controller,
    FocusNode? focusNode,
  }) : controller = controller ?? TextEditingController(),
       focusNode = focusNode ?? FocusNode();
  final GlobalKey<FormFieldState> fieldKey = GlobalKey<FormFieldState>();

  final TextEditingController controller;
  final FocusNode focusNode;

  set text(String value) => controller.text = value;

  String get text => controller.text;

  String? get validationError => fieldKey.currentState?.errorText;

  bool get hasFocus => focusNode.hasFocus;

  bool get isValid => fieldKey.currentState?.isValid ?? false;

  bool get isMultiline => controller.text.contains('\n');

  bool get isMounted => fieldKey.currentState?.mounted ?? false;

  void clear() => controller.clear();

  void dispose() => controller.dispose();
}

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/services.dart';

class InputFormatters {
  static TextInputFormatter percentage() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String text = newValue.text.replaceAll('%', ''); // Remove `%` for processing

      // Allow clearing the field completely
      if (text.isEmpty) {
        return newValue.copyWith(text: '');
      }

      // Allow only numbers and up to 2 decimal places
      final RegExp regex = RegExp(r'^\d{0,3}(\.\d{0,2})?$');
      if (!regex.hasMatch(text)) {
        return oldValue;
      }

      // Convert text to double for range validation
      final double? value = double.tryParse(text);
      if (value == null || value > 100) {
        return oldValue;
      }

      // If the previous value had a digit after '.' but now ends with '.', remove '.'
      if (oldValue.text.contains('.') && oldValue.text.split('.').last.isNotEmpty && text.endsWith('.')) {
        text = text.substring(0, text.length - 1); // Remove trailing dot
      }

      // Ensure text always ends with '%' but keep cursor position intact
      String newText = '$text%';
      int newOffset = newText.length; // Keep cursor at the right position

      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newOffset - 1), // Keep cursor before `%`
      );
    });
  }

  InputFormatters._();

  static List<TextInputFormatter> phone(CountryCode country) {
    final maxLimit = countryPhoneLengths[country.code.toLowerCase()]?['max'] ?? 10;
    final formatter = [
      TextInputFormatter.withFunction((oldValue, newValue) {
        final digits = newValue.text.replaceAll(RegExp(r'\D'), ''); // Keep only digits
        if (oldValue.text.length == maxLimit && digits.length > maxLimit) return oldValue; // Ignore if oldValue is perfect and newValue is too long
        final result = digits.length > maxLimit ? digits.substring(digits.length - maxLimit) : digits; // Keep last 10 digits
        return TextEditingValue(
          text: result,
          selection: TextSelection.collapsed(offset: result.length), // Update caret position
        );
      }),
    ];
    return formatter;
  }

  static List<TextInputFormatter> usaZipCode() {
    return [
      TextInputFormatter.withFunction((oldValue, newValue) {
        String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
        if (digits.length <= 5) {
          return TextEditingValue(
            text: digits,
            selection: TextSelection.collapsed(offset: digits.length),
          );
        } else if (digits.length <= 10) {
          final formatted = '${digits.substring(0, 5)}-${digits.substring(5)}';
          return TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        } else {
          final truncated = '${digits.substring(0, 5)}-${digits.substring(5, 10)}';
          return TextEditingValue(
            text: truncated,
            selection: TextSelection.collapsed(offset: truncated.length),
          );
        }
      }),
    ];
  }

  static String applyTextInputFormatters({
    required List<TextInputFormatter> formatters,
    required String inputText,
  }) {
    const oldValue = TextEditingValue.empty;
    final newValue = TextEditingValue(text: inputText);

    TextEditingValue result = newValue;

    for (final formatter in formatters) {
      result = formatter.formatEditUpdate(oldValue, result);
    }

    return result.text;
  }
}

const Map<String, Map<String, int>> countryPhoneLengths = {
  'gb': {'min': 10, 'max': 11},
  'de': {'min': 11, 'max': 11},
  'fr': {'min': 9, 'max': 9},
  'in': {'min': 10, 'max': 10},
  'br': {'min': 11, 'max': 11},
  'au': {'min': 9, 'max': 9},
  'jp': {'min': 10, 'max': 10},
  'za': {'min': 10, 'max': 10},
  'es': {'min': 9, 'max': 9},
  'it': {'min': 9, 'max': 10},
  'mx': {'min': 10, 'max': 10},
  'us': {'min': 10, 'max': 10},
  'cn': {'min': 11, 'max': 11},
  'eg': {'min': 10, 'max': 10},
  'th': {'min': 9, 'max': 9},
  'kr': {'min': 10, 'max': 10},
  'tr': {'min': 10, 'max': 10},
};

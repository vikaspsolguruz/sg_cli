import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/constants/regex.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/core/utils/input_formatters.dart';

class Validators {
  Validators._();

  static String? url(String url) {
    final RegExp pattern = RegExp(
      r'\b((http(s)?://www\.|http(s)?://|www\.)[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+(:\d+)?(/\S*)?)\b',
      caseSensitive: false,
    );
    final Iterable<RegExpMatch> matches = pattern.allMatches(url);
    if (matches.isEmpty) {
      return AppStrings.invalidUrl.tr;
    }
    for (final RegExpMatch match in matches) {
      String url = match.group(0)!;
      if (!url.startsWith(RegExp(r'http'))) {
        url = 'http://$url';
      }
      final Uri? uri = Uri.tryParse(url);
      if (uri != null && uri.host.isNotEmpty) {
        return null;
      }
    }
    return AppStrings.invalidUrl.tr;
  }

  static String? email(String? email) {
    if (email?.isEmpty ?? true) {
      return AppStrings.emailIsRequired.tr;
    } else if (!emailRegex.hasMatch(email!)) {
      return AppStrings.validEmailMessage;
    }
    return null;
  }

  static String? strongPassword(String? password) {
    if (password?.isEmpty ?? true) {
      return AppStrings.passwordIsRequired.tr;
    } else if (!passwordRegex.hasMatch(password!)) {
      return AppStrings.invalidPassword.tr;
    }
    return null;
  }

  static String? password(String? password) {
    if (password?.isEmpty ?? true) {
      return AppStrings.passwordIsRequired.tr;
    }
    return null;
  }

  static String? currentPassword(String? password) {
    if (password?.isEmpty ?? true) {
      return AppStrings.passwordIsRequired.tr;
    }
    if (!min8CharsRegex.hasMatch(password!)) {
      return AppStrings.passwordShouldBeAtLeast8Characters.tr;
    }
    return null;
  }

  static String? passwordWithConfirm(String? password, {TextEditingController? confirmPasswordController, bool checkMatch = false}) {
    String? validator(String? password) {
      if (password?.isEmpty ?? true) {
        return AppStrings.passwordIsRequired.tr;
      }
      if (!passwordRegex.hasMatch(password!)) {
        return AppStrings.passwordRulesDescription.tr;
      }
      if (confirmPasswordController?.text != password) {
        return AppStrings.passwordsDoNotMatch;
      }
      return null;
    }

    return validator(password);
  }

  static String? confirmPassword(String? password, {TextEditingController? passwordController}) {
    String? validator(String? password) {
      if (password?.isEmpty ?? true) {
        return AppStrings.passwordIsRequired.tr;
      }
      // if (!passwordRegex.hasMatch(password!)) {
      //   return AppStrings.passwordRulesDescription.tr;
      // }
      if (passwordController?.text != password) {
        return AppStrings.passwordsDoNotMatch.tr;
      }
      return null;
    }

    return validator(password);
  }

  static String? Function(String?)? required(
    String value, {
    String? label,
    int? minLength,
    int? maxLength,
    required bool isRequired,
  }) {
    String? validator(String? value) {
      if (value?.trim().isEmpty ?? true) {
        return isRequired ? '${label ?? AppStrings.field.tr} ${AppStrings.isRequired.tr}' : null;
      }
      if (minLength != null && (value?.length ?? 0) < minLength) {
        return '${label ?? AppStrings.field.tr} ${AppStrings.mustBeAtLeastNCharacters.replaceAll("{No}", "$minLength")}';
      }
      if (maxLength != null && (value?.length ?? 0) > maxLength) {
        return '${label ?? AppStrings.field.tr} ${AppStrings.mustBeAtMostNCharacters.replaceAll("{No}", "$maxLength")}';
      }
      return null;
    }

    return validator;
  }

  static String? Function(String? text) phoneInternational({required CountryCode country}) {
    String? validator(String? phone) {
      final int minLimit = countryPhoneLengths[country.code.toLowerCase()]?['min'] ?? 10;
      if (phone?.isEmpty ?? true) {
        return AppStrings.phoneNumberCanNotBeEmpty.tr;
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(phone!) || phone.length < minLimit) {
        return AppStrings.phoneNumberShouldBeAtLeast10Digits.tr;
      }
      return null;
    }

    return validator;
  }

  // prepare validation for double values
  static String? Function(String?)? doubleValue({
    String? label,
    bool isRequired = false,
  }) {
    String? validator(String? value) {
      if (isRequired && (value?.isEmpty ?? true)) {
        return '${label ?? AppStrings.field.tr} ${AppStrings.isRequired.tr}';
      }
      if (value?.isEmpty ?? true) {
        return null; // Allow empty values if not required
      }
      final doubleValue = double.tryParse(value!);
      if (doubleValue == null) {
        return '${label ?? AppStrings.field.tr} ${AppStrings.isInvalid.tr}';
      }
      return null;
    }

    return validator;
  }

  static String? usaZipCode(String? zipCode) {
    if (zipCode?.isEmpty ?? true) {
      return AppStrings.zipCodeNotEmptyMessage;
    }
    if ((zipCode?.length ?? 0) < 5) {
      return AppStrings.invalidZipCode;
    }
    return null;
  }
}

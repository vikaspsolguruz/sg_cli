import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/constants/regex.dart';
import 'package:newarch/core/models/password_validation_model.dart';
import 'package:newarch/core/utils/extensions.dart';

List<PasswordValidationModel> passwordValidations = [
  PasswordValidationModel(regEx: min8CharsRegex, errorMessage: AppStrings.passwordCharactersLimit.tr),
  PasswordValidationModel(regEx: min1UppercaseRegex, errorMessage: AppStrings.passwordUppercaseCharacterMessage.tr),
  PasswordValidationModel(regEx: min1LowercaseRegex, errorMessage: AppStrings.passwordLowercaseCharacterMessage.tr),
  PasswordValidationModel(regEx: min1DigitRegex, errorMessage: AppStrings.passwordDigitMessage.tr),
  PasswordValidationModel(regEx: specialCharRegex, errorMessage: AppStrings.passwordSpecialCharactersMessage.tr),
];

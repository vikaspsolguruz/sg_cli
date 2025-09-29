class PasswordValidationModel {
  final RegExp regEx;
  final String errorMessage;

  PasswordValidationModel({
    required this.regEx,
    required this.errorMessage,
  });

  bool isValid(String password) {
    return regEx.hasMatch(password);
  }
}

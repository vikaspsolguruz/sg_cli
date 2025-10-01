import 'package:newarch/environments/environments.dart';

class ApiLinks {
  ApiLinks._();

  static final baseUrl = apiBaseUrls[currentEnvironment] ?? 'http://localhost:3000';

  // Upload
  static final uploadFile = '$baseUrl/upload';
  static final uploadImage = '$baseUrl/upload/image';
  static final uploadImages = '$baseUrl/upload/photos';

  // Auth
  static final signUp = '$baseUrl/auth/signup/send-email-link';
  static final login = '$baseUrl/auth/login-email';
  static final logInGoogle = '$baseUrl/auth/google';
  static final logInApple = '$baseUrl/auth/apple';
  static final sendLinkToResetPassword = '$baseUrl/auth/forgot-password';
  static final sendLinkToResetPasswordProfile = '$baseUrl/auth/profile/forgot-password';
  static final verifyEmailForSignUp = '$baseUrl/auth/signup/verify-email';
  static final resetPassword = '$baseUrl/auth/reset-password';
  static final resetPassWordWithProfile = '$baseUrl/auth/profile/reset-password';
  static final logout = '$baseUrl/auth/logout';
  static final deleteAccount = '$baseUrl/users/account';
  static final changePassword = '$baseUrl/users/change-password';
}

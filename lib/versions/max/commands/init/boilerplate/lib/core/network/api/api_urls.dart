import 'package:max_arch/environments/environments.dart';

class ApiLinks {
  ApiLinks._();

  static final baseUrl = apiBaseUrls[currentEnvironment] ?? 'http://localhost:3000';

  // Upload
  static final uploadImage = '$baseUrl/upload/image';
  static final uploadImages = '$baseUrl/upload/photos';

  // Auth
  static final signUp = '$baseUrl/auth/signup/send-email-link';
  static final login = '$baseUrl/auth/login-email';
  static final logInGoogle = '$baseUrl/auth/google';
  static final logInApple = '$baseUrl/auth/apple';
  static final verifyEmailForSignUp = '$baseUrl/auth/signup/verify-email';
  static final resetPassword = '$baseUrl/auth/reset-password';
  static final resetPassWordWithProfile = '$baseUrl/auth/profile/reset-password';
  static final logout = '$baseUrl/auth/logout';
  static final deleteAccount = '$baseUrl/users/account';
  static final changePassword = '$baseUrl/users/change-password';

  // Misc
  static final updateFcmToken = '$baseUrl/users/update-fcm-token';
}

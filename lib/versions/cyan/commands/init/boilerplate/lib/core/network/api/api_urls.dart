import 'package:newarch/environments/environments.dart';

class ApiLinks {
  ApiLinks._();

  static final baseUrl = apiBaseUrls[currentEnvironment] ?? 'http://localhost:3000';

  // Upload
  static final uploadFile = '$baseUrl/upload';
  static final uploadImage = '$baseUrl/upload/image';
  static final uploadImages = '$baseUrl/upload/photos';

  //Radon Builder
  static final getRadonElements = '$baseUrl/drawing-components';
  static final drawings = '$baseUrl/drawings';

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

  // User
  static final setupProfile = '$baseUrl/users/setup-profile';
  static final getProfile = '$baseUrl/users/my-profile';
  static final updateProfile = '$baseUrl/users/my-profile';
  static final changePassword = '$baseUrl/users/change-password';
  static final deleteAccount = '$baseUrl/users/account';

  // Project
  static final projects = '$baseUrl/projects';
  static final cloneProject = '$baseUrl/projects/clone';
  static final checkListSubmissions = '$baseUrl/checklist-submissions';

  // Post mitigation
  static final postMitigationTest = '$baseUrl/post-mitigation-tests';

  // Site Assessment
  static final siteAssessments = '$baseUrl/site-assessments';

  //Report
  static final uploadReport = '$baseUrl/bill-of-materials';
}


import 'package:google_sign_in/google_sign_in.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:newarch/core/utils/toast/toast.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthService {
  static SocialAuthService? _instance = SocialAuthService._internal();

  factory SocialAuthService() {
    return _instance ??= SocialAuthService._internal();
  }

  SocialAuthService._internal();

  // Future<bool> loginWithGoogle() async {
  //   GoogleSignInAccount? googleUser;
  //   final signInOption = GoogleSignIn(scopes: ['email', 'profile']);
  //   try {
  //     googleUser = await signInOption.signIn();
  //   } catch (e, s) {
  //     xErrorPrint(e, stackTrace: s);
  //   }
  //   if (googleUser == null) {
  //     Toast.show(AppStrings.googleLoginError, isPositive: false);
  //     return false;
  //   }
  //   final response = await AuthRepository.logInWithGoogle(email: googleUser.email, socialId: googleUser.id);
  //   if (response.hasError) {
  //     Toast.show(response.message, isPositive: false);
  //     return false;
  //   }
  //   final user = response.data!..name ??= googleUser.displayName;
  //   await GlobalDataManager.saveUser(user);
  //   return true;
  // }

  // Future<bool> loginWithApple() async {
  //   AuthorizationCredentialAppleID? appleUser;
  //   try {
  //     appleUser = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );
  //   } catch (e, s) {
  //     xErrorPrint(e, stackTrace: s);
  //   }
  //   if (appleUser == null || appleUser.userIdentifier == null) {
  //     Toast.show(AppStrings.appleLoginError, isPositive: false);
  //     return false;
  //   }
  //   final response = await AuthRepository.logInWithApple(email: appleUser.email, socialId: appleUser.userIdentifier!);
  //   if (response.hasError) {
  //     Toast.show(response.message, isPositive: false);
  //     return false;
  //   }
  //   final user = response.data!..name ??= "${appleUser.givenName ?? ''} ${appleUser.familyName ?? ''}".trim().nullable;
  //   await GlobalDataManager.saveUser(user);
  //   return true;
  // }

  // Future<void> logout() async {
  //   await GoogleSignIn().signOut();
  // }
}

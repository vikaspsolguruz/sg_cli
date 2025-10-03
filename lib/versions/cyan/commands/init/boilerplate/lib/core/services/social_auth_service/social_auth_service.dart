import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/repositories/auth_repository.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:newarch/core/utils/extensions.dart';
import 'package:newarch/core/utils/global_data_manager.dart';
import 'package:newarch/core/utils/toast/toast.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialAuthService {
  static SocialAuthService? _instance = SocialAuthService._internal();

  factory SocialAuthService() {
    return _instance ??= SocialAuthService._internal();
  }

  SocialAuthService._internal();

  Future<bool> loginWithGoogle() async {
    GoogleSignInAccount? googleUser;
    const scopes = ['email', 'profile'];

    try {
      // Authenticate using the new API (v7.x) with scopes
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        googleUser = await GoogleSignIn.instance.authenticate(scopeHint: scopes);
      } else {
        // Fallback: This shouldn't happen on modern platforms
        Toast.show(AppStrings.googleLoginError, isPositive: false);
        return false;
      }
    } on GoogleSignInException catch (e, s) {
      xErrorPrint('Google Sign-In failed: ${e.code} - ${e.description}', stackTrace: s);
      // User cancelled sign-in, don't show error toast
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return false;
      }
      Toast.show(AppStrings.googleLoginError, isPositive: false);
      return false;
    } catch (e, s) {
      xErrorPrint('Unexpected Google Sign-In error: $e', stackTrace: s);
      Toast.show(AppStrings.googleLoginError, isPositive: false);
      return false;
    }

    final response = await AuthRepository.logInWithGoogle(
      email: googleUser.email,
      socialId: googleUser.id,
    );

    if (response.hasError) {
      Toast.show(response.message, isPositive: false);
      return false;
    }

    final user = response.data!..name ??= googleUser.displayName;
    await GlobalDataManager.saveUser(user);
    return true;
  }

  Future<bool> loginWithApple() async {
    AuthorizationCredentialAppleID? appleUser;
    try {
      appleUser = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } catch (e, s) {
      xErrorPrint(e, stackTrace: s);
    }
    if (appleUser == null || appleUser.userIdentifier == null) {
      Toast.show(AppStrings.appleLoginError, isPositive: false);
      return false;
    }
    final response = await AuthRepository.logInWithApple(email: appleUser.email, socialId: appleUser.userIdentifier!);
    if (response.hasError) {
      Toast.show(response.message, isPositive: false);
      return false;
    }
    final user = response.data!..name ??= "${appleUser.givenName ?? ''} ${appleUser.familyName ?? ''}".trim().nullable;
    await GlobalDataManager.saveUser(user);
    return true;
  }

  Future<void> logout() async {
    await GoogleSignIn.instance.disconnect();
  }
}

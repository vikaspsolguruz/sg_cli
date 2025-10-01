import 'package:flutter/material.dart';

/// Centralized widget keys for the entire application
///
/// These keys are used for both UI implementation and testing
///
/// Designed for consistency, maintainability, and sg_cli code generation
class Keys {
  // Private constructor to prevent instantiation
  Keys._();

  // ==================== Authentication Screen Keys ====================
  
  /// Login Screen Keys
  static const loginEmailFieldKey = Key('login_email_field');
  static const loginPasswordFieldKey = Key('login_password_field');
  static const loginButtonKey = Key('login_button');
  static const loginForgotPasswordKey = Key('login_forgot_password');
  static const loginSignUpKey = Key('login_sign_up');
  
  /// Signup Screen Keys (for future use)
  static const signupEmailFieldKey = Key('signup_email_field');
  static const signupPasswordFieldKey = Key('signup_password_field');
  static const signupConfirmPasswordFieldKey = Key('signup_confirm_password_field');
  static const signupButtonKey = Key('signup_button');
  
  // ==================== Home Screen Keys ====================
  
  /// Home Screen Keys (for future use)
  static const homeScreenKey = Key('home_screen');
  static const homeDrawerKey = Key('home_drawer');
  static const homeAppBarKey = Key('home_app_bar');
  
  // ==================== Profile Screen Keys ====================
  
  /// Profile Screen Keys (for future use)
  static const profileScreenKey = Key('profile_screen');
  static const profileEditButtonKey = Key('profile_edit_button');
  static const profileLogoutButtonKey = Key('profile_logout_button');
  
  // ==================== Common Widget Keys ====================
  
  /// Common Button Keys
  static const confirmButtonKey = Key('confirm_button');
  static const cancelButtonKey = Key('cancel_button');
  static const submitButtonKey = Key('submit_button');
  
  /// Common Dialog Keys
  static const errorDialogKey = Key('error_dialog');
  static const successDialogKey = Key('success_dialog');
  static const confirmDialogKey = Key('confirm_dialog');
  
  /// Common Loading Keys
  static const loadingIndicatorKey = Key('loading_indicator');
  static const refreshIndicatorKey = Key('refresh_indicator');
}

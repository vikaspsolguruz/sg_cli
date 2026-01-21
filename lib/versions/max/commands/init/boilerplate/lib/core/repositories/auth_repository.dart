import 'dart:io';

import 'package:max_arch/core/data/current_user.dart';
import 'package:max_arch/core/models/response/normal_response_model.dart';
import 'package:max_arch/core/models/user_model.dart';
import 'package:max_arch/core/network/api/api_client.dart';
import 'package:max_arch/core/network/api/api_urls.dart';
import 'package:max_arch/core/utils/device_info.dart';
import 'package:max_arch/core/utils/extensions.dart';
import 'package:max_arch/core/utils/os_version.dart';

class AuthRepository {
  AuthRepository._();

  static Future<NormalResponse> signUpWithEmail({required String? email, required String? password}) async {
    final payload = {
      "email": email,
      "password": password,
    };
    final apiData = await ApiClient.instance.post(ApiLinks.signUp, body: payload);
    return apiData.getNormalResponse();
  }

  static Future<NormalResponse<UserModel>> loginWithEmail({required String email, required String password}) async {
    final deviceId = await getDeviceId();
    final osVersion = await getOSVersion();

    final payload = {
      "email": email,
      "password": password,
      "device_id": deviceId,
      "device_os": Platform.operatingSystem,
      "os_version": osVersion,
    };
    final apiData = await ApiClient.instance.post(ApiLinks.login, body: payload);
    return apiData.getNormalResponse<UserModel>(
      dataParser: (data) => UserModel.fromJson(data['data']),
    );
  }

  static Future<NormalResponse<UserModel>> logInWithGoogle({required String email, required String socialId}) async {
    final deviceId = await getDeviceId();
    final osVersion = await getOSVersion();
    final payload = {
      "email": email.toLowerCase(),
      "social_id": socialId,
      "type": "google",
      "device_id": deviceId,
      "device_os": Platform.operatingSystem,
      "os_version": osVersion,
    };

    final apiData = await ApiClient.instance.post(ApiLinks.logInGoogle, body: payload);
    return apiData.getNormalResponse<UserModel>(
      dataParser: (data) => UserModel.fromJson(data['data']),
    );
  }

  static Future<NormalResponse<UserModel>> logInWithApple({required String? email, required String socialId}) async {
    final deviceId = await getDeviceId();
    final osVersion = await getOSVersion();
    final payload = {
      "email": email?.toLowerCase().nullable,
      "social_id": socialId,
      "type": "apple",
      "device_id": deviceId,
      "device_os": Platform.operatingSystem,
      "os_version": osVersion,
    };

    final apiData = await ApiClient.instance.post(ApiLinks.logInApple, body: payload);
    return apiData.getNormalResponse<UserModel>(
      dataParser: (data) => UserModel.fromJson(data['data']),
    );
  }

  static Future<NormalResponse<UserModel>> verifyEmailForSignUp({required String? email, required String? code}) async {
    final deviceId = await getDeviceId();
    final osVersion = await getOSVersion();

    final payload = {
      "email": email,
      "code": int.tryParse(code ?? ''),
      "device_id": deviceId,
      "device_os": Platform.operatingSystem,
      "os_version": osVersion,
    };
    final apiData = await ApiClient.instance.post(ApiLinks.verifyEmailForSignUp, body: payload);
    return apiData.getNormalResponse<UserModel>(
      dataParser: (data) => UserModel.fromJson(data['data']),
    );
  }

  static Future<NormalResponse> resetPassword({required String email, required String code, required String password}) async {
    final payload = {
      "email": email,
      "code": int.tryParse(code),
      "password": password,
      "confirm_password": password,
    };
    final apiData = await ApiClient.instance.post(currentUser != null ? ApiLinks.resetPassWordWithProfile : ApiLinks.resetPassword, body: payload);
    return apiData.getNormalResponse();
  }

  static Future<NormalResponse> changePassword({required String currentPassword, required String newPassword, required String confirmPassword}) async {
    final payload = {
      "current_password": currentPassword,
      "new_password": newPassword,
      "confirm_password": confirmPassword,
    };
    final apiData = await ApiClient.instance.patch(ApiLinks.changePassword, body: payload);
    return apiData.getNormalResponse();
  }

  static Future<NormalResponse> deleteAccount({required String password}) async {
    final payload = {
      "password": password.nullable,
    };
    final apiData = await ApiClient.instance.delete(ApiLinks.deleteAccount, body: payload);
    return apiData.getNormalResponse();
  }

  static Future<NormalResponse> logOut() async {
    final apiData = await ApiClient.instance.get(ApiLinks.logout);
    return apiData.getNormalResponse();
  }
}

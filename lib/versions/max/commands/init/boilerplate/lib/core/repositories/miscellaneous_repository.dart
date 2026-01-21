import 'package:max_arch/core/models/response/normal_response_model.dart';
import 'package:max_arch/core/network/api/api_client.dart';
import 'package:max_arch/core/network/api/api_urls.dart';
import 'package:max_arch/core/utils/device_info.dart';

class MiscellaneousRepository {
  MiscellaneousRepository._();

  static Future<NormalResponse> updateFcmToken() async {
    final payload = {
      "device_id": await getDeviceId(),
      // "fcm_token": NativeNotificationService.fcmToken,
    };
    final rawResponse = await ApiClient.instance.patch(ApiLinks.updateFcmToken, body: payload);
    return rawResponse.getNormalResponse();
  }
}

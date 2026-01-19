import 'package:max_arch/core/models/response_data_model.dart';
import 'package:max_arch/core/network/api/api_client.dart';
import 'package:max_arch/core/network/api/api_urls.dart';
import 'package:max_arch/core/services/notification/native_notification_service.dart';
import 'package:max_arch/core/utils/device_info.dart';

class MiscellaneousRepository {
  MiscellaneousRepository._();

  static Future<ResponseData> updateFcmToken() async {
    final payload = {
      "device_id": await getDeviceId(),
      "fcm_token": NativeNotificationService.fcmToken,
    };
    final apiData = await ApiClient.instance.patch(ApiLinks.updateFcmToken, body: payload);
    return apiData.getResponseData();
  }
}

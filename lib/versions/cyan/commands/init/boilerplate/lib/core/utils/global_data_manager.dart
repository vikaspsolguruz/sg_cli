import 'package:newarch/core/data/current_user.dart';
import 'package:newarch/core/models/user_model.dart';
import 'package:newarch/core/network/api/api_client.dart';
import 'package:newarch/core/local_storage/local_storage.dart';

class GlobalDataManager {
  GlobalDataManager._();

  static void syncAll() {
    if (currentUser == null) return;
    syncUser();
    _getPosition();
  }

  static Future<void> syncUser() async {
    // final responseData = await MiscellaneousRepository.syncUser();
    // if (responseData.isSuccess) {
    //   final user = responseData.data!;
    //   currentUser?.copyFrom(user);
    //   await Prefs.setCurrentUser(currentUser);
    // }
  }

  static Future<void> saveUser(UserModel? user) async {
    if (user == null) return;
    currentUser = user;
    ApiClient.instance.setBaseToken(token: currentUser?.token);
    await LocalStorage.setCurrentUser(currentUser);
  }

  static Future<void> _getPosition() async {
    // final position = await LocationManager.getPosition();
    // if (position == null || currentUser?.role != UserRole.customer) return;
    //
    // List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    // final place = placeMarks.firstOrNull;
    // if (place == null) return;
    //
    // final fullAddress = [
    //   if (place.street != null) place.street,
    //   if (place.subLocality != null) place.subLocality,
    //   if (place.subAdministrativeArea != null) place.subAdministrativeArea,
    //   if (place.locality != null) place.locality,
    //   if (place.administrativeArea != null) place.administrativeArea,
    //   if (place.country != null) place.country,
    // ].join(", ");
    //
    // if (currentUser?.role != UserRole.customer) return;
    //
    // final response = await SetUpPreferenceRepository.addAddress(
    //   countryId: place.isoCountryCode ?? "",
    //   state: place.administrativeArea ?? place.subAdministrativeArea ?? "",
    //   city: place.locality ?? "",
    //   zipCode: place.postalCode ?? "",
    //   latitude: position.latitude.toString() ?? "",
    //   longitude: position.longitude.toString() ?? "",
    //   fullAddress: fullAddress,
    // );
    // if (response.hasError) {
    //   Future.delayed(const Duration(seconds: 3), () => _getPosition());
    //   return;
    // }
  }
}

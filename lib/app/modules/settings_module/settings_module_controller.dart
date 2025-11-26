import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsModuleController extends GetxController {
  final box = GetStorage();

  RxBool biometrics = false.obs;
  RxBool twoFA = false.obs;
  RxBool giveaway = false.obs;
  RxBool promo = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBiometricSetting();
  }

  @override
  void onReady() {
    super.onReady();
    loadBiometricSetting();
  }

  void loadBiometricSetting() {
    final storedValue = box.read('biometric_enabled');
    if (storedValue is bool) {
      biometrics.value = storedValue;
    } else if (storedValue is String) {
      biometrics.value = storedValue.toLowerCase() == 'true';
    } else {
      biometrics.value = false;
    }
  }
}
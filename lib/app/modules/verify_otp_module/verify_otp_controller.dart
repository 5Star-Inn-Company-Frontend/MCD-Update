import 'dart:async';

import 'package:get/get.dart';

import '../../../core/network/api_service.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class VerifyOtpController extends GetxController {
  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final _minutes = 4.obs;
  set minutes(value) => _minutes.value = value;
  get minutes => _minutes.value;

  final _seconds = 0.obs;
  set seconds(value) => _seconds.value = value;
  get seconds => _seconds.value;

  late Timer timer;
  final _isVerifying = false.obs;
  set isVerifying(value) => _isVerifying.value = value;
  get isVerifying => _isVerifying.value;

  @override
  void onInit() {
    obj = Get.arguments;
    sendCode();
    super.onInit();
  }

  void startTimer() {
    minutes = 4;
    seconds = 0;
    timer.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (minutes == 0 && seconds == 0) {
        timer.cancel();
      } else if (seconds == 0) {
        minutes -= 1;
        seconds = 59;
      } else {
        seconds -= 1;
      }
    });
  }

  ApiService apiService = ApiService();

  Future<void> sendCode() async {
    try {
      apiService.postrequest("/sendcode", {"email": obj});
      startTimer();
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

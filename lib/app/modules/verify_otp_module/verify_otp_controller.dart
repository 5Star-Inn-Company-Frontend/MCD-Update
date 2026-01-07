import 'dart:async';

import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:otp_text_field/otp_field.dart';

import '../../../core/network/dio_api_service.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class VerifyOtpController extends GetxController {
  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;
  
  // OTP field controller for better control
  final OtpFieldController otpController = OtpFieldController();

  final _minutes = 1.obs;
  set minutes(value) => _minutes.value = value;
  get minutes => _minutes.value;

  final _seconds = 0.obs;
  set seconds(value) => _seconds.value = value;
  get seconds => _seconds.value;

  Timer? timer;
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
    minutes = 1;
    seconds = 0;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (minutes == 0 && seconds == 0) {
        t.cancel();
      } else if (seconds == 0) {
        minutes -= 1;
        seconds = 59;
      } else {
        seconds -= 1;
      }
    });
  }

  var apiService = DioApiService();

  Future<void> sendCode() async {
    try {
      apiService.postrequest("${ApiConstants.authUrlV2}/sendcode", {"email": obj});
      startTimer();
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.clear();
    super.dispose();
  }
}

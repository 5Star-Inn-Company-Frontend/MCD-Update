import 'dart:async';

import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;

import 'package:mcd/core/network/api_constants.dart';

import '../../../core/network/dio_api_service.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class ResetPasswordController extends GetxController{

  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  var apiService = DioApiService();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  RxBool isEmail = false.obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final RxBool isOtpSent = false.obs;
  RxBool isValid = false.obs;

  RxInt minutes = 4.obs;
  RxInt seconds = 0.obs;
  late Timer timer;

  bool get canResend => minutes.value == 0 && seconds.value == 0;

  void startTimer({int startMinutes = 4, int startSeconds = 0}) {
    // cancel any existing timer before starting a new one
    try {
      timer.cancel();
    } catch (_) {}
    minutes.value = startMinutes;
    seconds.value = startSeconds;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (minutes.value == 0 && seconds.value == 0) {
        t.cancel();
      } else if (seconds.value == 0) {
        minutes.value -= 1;
        seconds.value = 59;
      } else {
        seconds.value -= 1;
      }
    });
  }

  void cancelTimer() {
    try {
      timer.cancel();
    } catch (_) {}
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void dispose() {
    cancelTimer();
    emailController.dispose();
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void validateInput() {
    if (formKey3.currentState == null) return;
    if (formKey3.currentState!.validate()) {
        isValid.value = true;
    } else {
        isValid.value = true;
    }
  }


  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await apiService.postrequest(
        "${ApiConstants.authUrlV2}/resetpassword",
        {
          "email": email.trim()
        }
      );

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log("Reset password error: ${errorMessage.value}");
          Get.snackbar("Error", errorMessage.value!);
        },
        (data) {
          dev.log("Reset password response: $data");
          final success = data['success'];
          
          if (success == 1) {
            isOtpSent.value = true;
            dev.log("OTP sent successfully to $email");
            Get.snackbar("Success", data['message'] ?? "OTP sent to $email");
            Get.toNamed(Routes.VERIFY_RESET_PASSWORD_OTP, arguments: {'email': email});
          } else {
            errorMessage.value = data['message'] ?? "Failed to send OTP";
            dev.log("Reset password failed: ${errorMessage.value}");
            Get.snackbar("Error", errorMessage.value!);
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = "Unexpected error: $e";
      dev.log("Reset password exception: $e");
      Get.snackbar("Error", errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPasswordCheck(BuildContext context, String email, String code) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;
      dev.log("Verifying code: $code for email: $email");

      final result = await apiService.postrequest(
        "${ApiConstants.authUrlV2}/resetpassword-check",
        {
          "email": email.trim(),
          'code': code.trim()
        }
      );

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log("Code verification error: ${errorMessage.value}");
          Get.snackbar("Error", errorMessage.value!);
        },
        (data) {
          dev.log("Code verification response: $data");
          final success = data['success'];
          
          if (success == 1) {
            dev.log("Code verified successfully");
            Get.snackbar("Success", data['message'] ?? "Code is valid");
            Get.toNamed(Routes.CHANGE_RESET_PASSWORD, arguments: {'email': email, 'code': code});
          } else {
            errorMessage.value = data['message'] ?? "Invalid code";
            dev.log("Code verification failed: ${errorMessage.value}");
            Get.snackbar("Error", errorMessage.value!);
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = "Unexpected error: $e";
      dev.log("Code verification exception: $e");
      Get.snackbar("Error", errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeResetPassword(BuildContext context, String email, String code, String password) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;
      dev.log("Changing password for: $email");

      final result = await apiService.putrequest(
        "${ApiConstants.authUrlV2}/resetpassword",
        {
          "email": email.trim(),
          'code': code.trim(),
          'password': password.trim()
        }
      );

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log("Password change error: ${errorMessage.value}");
          Get.snackbar("Error", errorMessage.value!);
        },
        (data) {
          dev.log("Password change response: $data");
          final success = data['success'];
          
          if (success == 1) {
            dev.log("Password changed successfully");
            Get.snackbar("Success", data['message'] ?? "Password changed successfully");
            // Navigate to login after success
            Future.delayed(const Duration(seconds: 1), () {
              Get.offAllNamed(Routes.LOGIN_SCREEN);
            });
          } else {
            errorMessage.value = data['message'] ?? "Failed to change password";
            dev.log("Password change failed: ${errorMessage.value}");
            Get.snackbar("Error", errorMessage.value!);
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = "Unexpected error: $e";
      dev.log("Password change exception: $e");
      Get.snackbar("Error", errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp(BuildContext context, String email) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;
      dev.log("Resending OTP to: $email");

      final result = await apiService.postrequest(
        "${ApiConstants.authUrlV2}/resetpassword",
        {
          "email": email.trim()
        }
      );

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log("Resend OTP error: ${errorMessage.value}");
          Get.snackbar("Error", errorMessage.value!);
        },
        (data) {
          dev.log("Resend OTP response: $data");
          final success = data['success'];
          if (success == 1) {
            isOtpSent.value = true;
            dev.log("OTP resent successfully to $email");
            Get.snackbar("Success", data['message'] ?? "OTP sent to $email");
            // Restart countdown on success
            startTimer();
          } else {
            errorMessage.value = data['message'] ?? "Failed to resend OTP";
            dev.log("Resend OTP failed: ${errorMessage.value}");
            Get.snackbar("Error", errorMessage.value!);
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = "Unexpected error: $e";
      dev.log("Resend OTP exception: $e");
      Get.snackbar("Error", errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }

}

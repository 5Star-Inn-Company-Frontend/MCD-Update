import 'dart:async';

import 'package:mcd/core/import/imports.dart';
import 'dart:developer' as dev;

import 'package:mcd/core/network/api_constants.dart';
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

  ApiService apiService = ApiService();

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

  @override
  void onInit() {
    // obj = Get.arguments;
    super.onInit();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
    
    if (minutes.value == 0 && seconds.value == 0) {
      timer.cancel();
    } else if (seconds.value == 0) {
      minutes.value -= 1;
      seconds.value = 59;
    } else {
      seconds.value -= 1;
    }
    });
  }

  @override
  void dispose() {
    timer.cancel();
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

      // final result = await authRepository.resetPassword(email);
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
          dev.log('isOtpSent: ${isOtpSent.value}');
          dev.log("Send code error: ${errorMessage.value}");
          Get.snackbar("Error", errorMessage.value!);
        },
        (success) {
          isOtpSent.value = true;
          dev.log('isOtpSent: ${isOtpSent.value}');
          dev.log('OTP sent to $email');
          Get.snackbar("Success", "OTP sent to $email");
          Get.toNamed(Routes.VERIFY_RESET_PASSWORD_OTP, arguments: {'email': email});
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = "Unexpected error: $e";
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
          dev.log("Send code error: ${errorMessage.value}");
          Get.snackbar("Error", errorMessage.value!);
        },
        (success) {
          dev.log("$success");
          Get.snackbar("Success", "$success");
          Get.toNamed(Routes.CHANGE_RESET_PASSWORD, arguments: {'email': email, 'code': code});
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = "Unexpected error: $e";
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

      final result = await apiService.postrequest(
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
          dev.log("Change Reset Password error: ${errorMessage.value}");
          Get.snackbar("Error", errorMessage.value!);
        },
        (success) {
          dev.log("$success");
          Get.snackbar("Success", "$success");
          // Get.toNamed(AppRoutes.changeResetPassword, arguments: {'email': email, 'code': code});
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = "Unexpected error: $e";
      Get.snackbar("Error", errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }


}

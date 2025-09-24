import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/widgets/loading_dialog.dart';
import 'package:mcd/features/auth/domain/entities/user_signup_data.dart';
import 'package:mcd/routes/app_routes.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController(this.authRepository);

  final box = GetStorage();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  UserSignupData? pendingSignupData;
  final RxBool isOtpSent = false.obs;


  Future<void> sendCode(BuildContext context, String email) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await authRepository.sendCode(email);

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
          Get.toNamed(AppRoutes.verifyOtp); // Navigate immediately after success
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

  Future<void> signup(BuildContext context, String otp) async {
    if (pendingSignupData == null) {
      dev.log("No pending signup data");
      Get.snackbar("Error", "No signup data found");
      return;
    }

    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await authRepository.signup(pendingSignupData!, otp);

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log("Signup error: ${errorMessage.value}");
          Get.snackbar("Error", errorMessage.value!);
        },
        (authResult) {
          if (authResult.success) {
            dev.log("Signup successful");
            Get.snackbar("Success", "Registration complete, please login");
            Get.offAllNamed(AppRoutes.login);
          } else {
            dev.log("Signup failed: ${authResult.message}");
            Get.snackbar("Error", authResult.message ?? "Signup failed");
          }
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

  // Future<void> login(BuildContext context, String username, String password) async {
  //   try {
  //     showLoadingDialog(context: context);
  //     isLoading.value = true;
  //     errorMessage.value = null;
  //     final result = await authRepository.login(username, password);
  //     Get.back(); // close loader
  //     result.fold(
  //       (failure) {
  //         errorMessage.value = failure.message;
  //         dev.log("Login error: ${errorMessage.value}");
  //         Get.snackbar("Error", errorMessage.value!);
  //       },
  //       (authResult) {
  //         if (authResult.requires2FA == true) {
  //           // redirect to PIN/2FA screen
  //           dev.log("2FA required, navigated to verification pin screen");
  //           Get.snackbar("Info", "2FA verification required");
  //           Get.toNamed(AppRoutes.verify2FA);
  //         } else if (authResult.success) {
  //           dev.log("Login successful");
  //           Get.snackbar("Success", "Welcome back!");
  //           // save token if needed
  //           box.write("token", authResult.token);
  //           Get.offAllNamed(AppRoutes.homenav);
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     Get.back();
  //     errorMessage.value = "Unexpected error: $e";
  //     Get.snackbar("Error", errorMessage.value!);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  
}

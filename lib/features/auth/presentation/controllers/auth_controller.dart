import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/widgets/loading_dialog.dart';
import 'package:mcd/features/auth/domain/entities/user_signup_data.dart';
import 'package:mcd/features/home/data/model/dashboard_model.dart';
import 'package:mcd/features/home/data/model/referral_model.dart';
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

  final dashboardData = Rxn<DashboardModel>();
  

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

  Future<void> login(BuildContext context, String username, String password) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await authRepository.login(username, password);

      Get.back();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.snackbar("Error", errorMessage.value!);
        },
        (data) async {
          final success = data['success'];
          if (success == 1 && data['token'] != null) {
            // normal login
            final token = data['token']; 
            await box.write('token', token);
            // Get.offAllNamed(AppRoutes.homenav);
            await handleLoginSuccess();
          } else if (success == 2 && data['pin'] == true) {
            // 2FA required
            Get.toNamed(AppRoutes.pinVerify, arguments: {"username": username});
          } else if (/* detect new device case */ data['message']?.contains("device") == true) {
            // new Device
            Get.toNamed(AppRoutes.newDeviceVerify, arguments: {"username": username});
          } else {
            Get.snackbar("Error", data['message'] ?? "Login failed");
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

  Future<void> verifyPin(BuildContext context, String username, String pin) async {
    final result = await authRepository.pinAuth(username, pin);
    result.fold(
      (failure) => Get.snackbar("Error", failure.message),
      (data) {
        if (data['success'] == 1) {
          final token = data['token'];
          box.write('token', token);
          Get.offAllNamed(AppRoutes.homenav);
        } else {
          Get.snackbar("Error", data['message'] ?? "PIN verification failed");
        }
      },
    );
  }

  Future<void> verifyNewDevice(BuildContext context, String username, String code) async {
    final result = await authRepository.verifyNewDevice(username, code);
    result.fold(
      (failure) => Get.snackbar("Error", failure.message),
      (data) {
        if (data['success'] == 1) {
          final token = data['token'];
          box.write('token', token);
          Get.offAllNamed(AppRoutes.homenav);
        } else {
          Get.snackbar("Error", data['message'] ?? "New device verification failed");
        }
      },
    );
  }

  Future<void> fetchDashboard({bool force = false}) async {
    // prevent multiple calls unless forced
    if (dashboardData.value != null && !force) {
      dev.log("Dashboard already loaded, skipping fetch");
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    final result = await authRepository.dashboard();

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        Get.snackbar("Error", failure.message);
      },
      (data) {
        dashboardData.value = data;
        dev.log("Dashboard updated: ${data.toString()}");
        if (force) {
          Get.snackbar("Updated", "Dashboard refreshed");
        }
      },
    );

    isLoading.value = false;
  }

  /// After login success, preload dashboard
  Future<void> handleLoginSuccess() async {
    await fetchDashboard(force: true);
    Get.offAllNamed(AppRoutes.homenav);
  }

  // caching referrals here
  final referrals = <ReferralModel>[].obs;

  /// Fetch referrals (cached by default)
  Future<void> fetchReferrals({bool force = false}) async {
    // Prevent multiple fetches unless forced
    if (referrals.isNotEmpty && !force) {
      dev.log("Referrals already loaded, skipping fetch");
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    final result = await authRepository.referrals();

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        dev.log("Referrals error: ${failure.message}");
        Get.snackbar("Error", failure.message);
      },
      (data) {
        referrals.assignAll(data);
        dev.log("Referrals updated: ${data.length} items");

        // Show snackbar only if this was a manual refresh
        if (force) {
          Get.snackbar("Updated", "Referrals refreshed");
        }
      },
    );

    isLoading.value = false;
  }

  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await authRepository.resetPassword(email);

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
          Get.toNamed(AppRoutes.verifyResetPasswordOtp, arguments: {'email': email});
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

      final result = await authRepository.resetPasswordCheck(email, code);

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
          Get.toNamed(AppRoutes.changeResetPassword, arguments: {'email': email, 'code': code});
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

      final result = await authRepository.changeResetPassword(email, code, password);

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

  Future<void> sendEmailVerifyCode(BuildContext context, String email) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await authRepository.sendEmailVerifyCode(email);

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
          // Get.toNamed(AppRoutes.verifyResetPasswordOtp, arguments: {'email': email});
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

  Future<void> emailVerifyConfirm(BuildContext context, String email, String code) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await authRepository.emailVerifyConfirm(email, code);

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

  Future<void> kycUpdate(BuildContext context, String bvn, String image) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await authRepository.kycUpdate(bvn, image);

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log("Kyc Update error: ${errorMessage.value}");
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

  Future<void> kycCheck(BuildContext context, String bvn) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await authRepository.kycCheck(bvn);

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log("Kyc Check error: ${errorMessage.value}");
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
  
  Future<void> kycValidate(BuildContext context, String bvn, String reference, String imageUrl) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await authRepository.kycValidate(bvn, reference, imageUrl);

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log("Kyc Check error: ${errorMessage.value}");
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class AddReferralModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final referralController = TextEditingController();
  final isSubmitting = false.obs;

  @override
  void onClose() {
    referralController.dispose();
    super.onClose();
  }

  Future<void> submitReferral() async {
    final referralCode = referralController.text.trim();

    if (referralCode.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a referral code",
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    isSubmitting.value = true;
    dev.log('Submitting referral code: $referralCode', name: 'AddReferral');

    try {
      final utilityUrl = box.read('utility_service_url');
      if (utilityUrl == null || utilityUrl.isEmpty) {
        dev.log('Utility URL not found',
            name: 'AddReferral', error: 'URL missing');
        Get.snackbar(
          "Error",
          "Service URL not found.",
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      final body = {
        "referral": referralCode,
      };

      dev.log('Request body: $body', name: 'AddReferral');
      final result =
          await apiService.postrequest('${utilityUrl}addreferral', body);

      result.fold(
        (failure) {
          dev.log('Referral submission failed',
              name: 'AddReferral', error: failure.message);
          Get.snackbar(
            "Submission Failed",
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('Referral response: $data', name: 'AddReferral');
          if (data['success'] == 1 || data['status'] == 'success') {
            dev.log('Referral submitted successfully', name: 'AddReferral');
            Get.snackbar(
              "Success",
              data['message'] ?? "Referral code added successfully!",
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
            );
            referralController.clear();
            // Navigate back after a short delay
            Future.delayed(const Duration(seconds: 2), () {
              Get.back();
            });
          } else {
            dev.log('Referral submission unsuccessful',
                name: 'AddReferral', error: data['message']);
            Get.snackbar(
              "Submission Failed",
              data['message'] ?? "Could not add referral code.",
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log("Referral submission error", name: 'AddReferral', error: e);
      Get.snackbar(
        "Error",
        "An unexpected error occurred.",
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}

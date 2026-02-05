import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class JambVerfyAccountModuleController extends GetxController {
  final profileCodeController = TextEditingController();
  final isLoading = false.obs;
  final isValidating = false.obs;

  // exam data from api
  Map<String, dynamic>? selectedExam;

  final apiService = DioApiService();
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['selectedExam'] != null) {
      selectedExam = args['selectedExam'];
      dev.log('Selected exam: $selectedExam', name: 'JambVerify');
    }
  }

  // getters for exam data
  String get examName => selectedExam?['name'] ?? 'Unknown';
  String get variationCode => selectedExam?['variation_code'] ?? '';
  String get amount => (selectedExam?['variation_amount'] ?? 0).toString();

  // map variation_code to provider for validation
  String get provider {
    final code = variationCode.toLowerCase();
    if (code.startsWith('utme')) return 'utme';
    return code; // de stays as de
  }

  @override
  void onClose() {
    profileCodeController.dispose();
    super.onClose();
  }

  Future<void> pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData != null && clipboardData.text != null) {
      profileCodeController.text = clipboardData.text!;
    }
  }

  Future<void> verifyAccount() async {
    if (profileCodeController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter profile code',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
      return;
    }

    isValidating.value = true;
    dev.log(
        'Starting account validation for profile code: ${profileCodeController.text}',
        name: 'JambVerify');

    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        dev.log('Transaction URL not found',
            name: 'JambVerify', error: 'URL missing');
        Get.snackbar(
          'Error',
          'Transaction URL not found.',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      final body = {
        "service": "jamb",
        "provider": provider,
        "number": profileCodeController.text.trim(),
      };

      dev.log('Validation request body: $body', name: 'JambVerify');
      final result =
          await apiService.postrequest('${transactionUrl}validate', body);

      result.fold(
        (failure) {
          dev.log('Validation failed',
              name: 'JambVerify', error: failure.message);
          Get.snackbar(
            'Validation Failed',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
          );
        },
        (data) {
          dev.log('Validation response: $data', name: 'JambVerify');
          if (data['success'] == 1) {
            dev.log('Validation successful, navigating to payment',
                name: 'JambVerify');
            Get.toNamed(
              Routes.JAMB_PAYMENT_MODULE,
              arguments: {
                'selectedExam': selectedExam,
                'profileCode': profileCodeController.text,
                'validationData': data['data'],
              },
            );
          } else {
            dev.log('Validation unsuccessful',
                name: 'JambVerify', error: data['message']);
            Get.snackbar(
              'Validation Failed',
              data['message'] ?? 'Unable to verify profile code.',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
            );
          }
        },
      );
    } catch (e) {
      dev.log('Validation error', name: 'JambVerify', error: e);
      Get.snackbar(
        'Error',
        'An unexpected error occurred during validation.',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      isValidating.value = false;
    }
  }
}

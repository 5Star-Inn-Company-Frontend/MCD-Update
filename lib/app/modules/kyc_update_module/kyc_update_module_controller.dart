import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/login_screen_module/login_screen_controller.dart';
import 'package:sprint_check/sprint_check.dart';
import 'package:sprint_check/sprint_check_method_channel.dart';
import 'dart:developer' as dev;

import '../../styles/app_colors.dart';

class KycUpdateModuleController extends GetxController {
  final box = GetStorage();
  final sprintCheckPlugin = SprintCheck();
  final LoginScreenController authController = Get.find<LoginScreenController>();

  final bvnController = TextEditingController();
  final identifierController = TextEditingController();
  
  final isLoading = false.obs;
  final isBvnVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('KycUpdateModuleController initialized', name: 'KycUpdate');
    initializeSprintCheck();
    checkBvnStatus();
    setIdentifier();
  }

  @override
  void onClose() {
    bvnController.dispose();
    identifierController.dispose();
    super.onClose();
  }

  void initializeSprintCheck() {
    try {
      sprintCheckPlugin.initialize(
        api_key: "YOUR_ACTUAL_SPRINT_CHECK_API_KEY_HERE",
        encryption_key: "YOUR_ACTUAL_SPRINT_CHECK_ENCRYPTION_KEY_HERE",
      );
      dev.log('Sprint Check SDK initialized', name: 'KycUpdate');
    } catch (e) {
      dev.log('Error initializing Sprint Check SDK', name: 'KycUpdate', error: e);
    }
  }

  void setIdentifier() {
    // Use email as identifier - ensure it's not empty
    final email = authController.dashboardData?.user.email ?? '';
    if (email.isNotEmpty) {
      identifierController.text = email;
      dev.log('Identifier set: $email', name: 'KycUpdate');
    } else {
      // Fallback to username if email is not available
      final username = authController.dashboardData?.user.userName ?? '';
      identifierController.text = username;
      dev.log('Identifier set to username: $username', name: 'KycUpdate');
    }
  }

  void checkBvnStatus() {
    // Check if BVN is already verified from dashboard data
    final bvnValid = authController.dashboardData?.user.bvn ?? false;
    isBvnVerified.value = bvnValid;
    dev.log('BVN verification status: $bvnValid', name: 'KycUpdate');
  }

  Future<void> startBvnVerification(BuildContext context) async {
    if (bvnController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your BVN',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (bvnController.text.length != 11) {
      Get.snackbar(
        'Error',
        'BVN must be 11 digits',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      dev.log('Starting BVN verification for: ${bvnController.text}', name: 'KycUpdate');
      dev.log('Using identifier: ${identifierController.text}', name: 'KycUpdate');

      // Ensure we pass string values, not controllers
      final identifier = identifierController.text.trim();
      final bvnNumber = bvnController.text.trim();

      if (identifier.isEmpty) {
        Get.snackbar(
          'Error',
          'User identifier is missing. Please try logging out and back in.',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
          snackPosition: SnackPosition.TOP,
        );
        isLoading.value = false;
        return;
      }

      final response = await sprintCheckPlugin.checkout(
        context,
        CheckoutMethod.bvn,
        identifier,
        bvn: bvnNumber,
      );

      dev.log('BVN verification response: $response', name: 'KycUpdate');

      // Parse response and handle success/failure
      handleVerificationResponse(response);
    } catch (e) {
      dev.log('Error during BVN verification', name: 'KycUpdate', error: e);
      Get.snackbar(
        'Error',
        'Verification failed: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void handleVerificationResponse(dynamic response) {
    // Handle the Sprint Check SDK response
    // You may need to adjust this based on actual response structure
    dev.log('Processing verification response', name: 'KycUpdate');
    
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info_outline,
              size: 50,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 20),
            const Text(
              'Verification Result',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Response: $response',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void showAlreadyVerifiedDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 50,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Already Verified',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your BVN has already been verified.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

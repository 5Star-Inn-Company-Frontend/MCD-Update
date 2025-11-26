import 'package:mcd/core/import/imports.dart';
import 'package:flutter/material.dart';

class MoreModuleController extends GetxController with GetSingleTickerProviderStateMixin {
  final LoginScreenController authController = Get.find<LoginScreenController>();
  
  late TabController tabController;
  final args = Get.arguments as Map<String, dynamic>?;
  
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 5, vsync: this);
    
    // Set initial tab if specified
    final initialTab = args?['initialTab'] as int?;
    if (initialTab != null && initialTab >= 0 && initialTab < 5) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tabController.animateTo(initialTab);
      });
    }
  }
  
  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
  
  Future<void> logoutUser() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.white,
        title: TextSemiBold(
          'Confirm Logout',
          fontSize: 18,
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.manRope,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: TextSemiBold(
              'Cancel',
              fontSize: 14,
              color: AppColors.primaryGrey2,
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: TextSemiBold(
              'Logout',
              fontSize: 14,
              color: AppColors.errorBgColor,
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    // If user confirmed, proceed with logout
    if (confirmed == true) {
      await authController.logout();
      Get.offAllNamed(Routes.LOGIN_SCREEN);
    }
  }
}
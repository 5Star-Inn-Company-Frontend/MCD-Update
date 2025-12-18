import 'package:mcd/core/import/imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

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
  
  // get user's referral code (username)
  String getReferralCode() {
    return authController.dashboardData?.user.userName ?? '';
  }

  // copy referral code to clipboard
  Future<void> copyReferralCode() async {
    final referralCode = getReferralCode();
    if (referralCode.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: referralCode));
      Get.snackbar(
        'Copied!',
        'Referral code copied to clipboard',
        backgroundColor: AppColors.successBgColor,
        colorText: AppColors.textSnackbarColor,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // share referral code
  Future<void> shareReferralCode() async {
    final referralCode = getReferralCode();
    if (referralCode.isNotEmpty) {
      final message = 'Use my referral code "$referralCode" to join MEGA Cheap Data and enjoy amazing bonuses! Download now: https://play.google.com/store/apps/details?id=a5starcompany.com.megacheapdata';
      await Share.share(message);
    }
  }

  // navigate to referral list
  void viewReferralList() {
    Get.toNamed(Routes.REFERRAL_LIST_MODULE);
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
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class RewardCentreModuleController extends GetxController {
  RewardedAd? _rewardedAd;
  final isAdLoading = false.obs;
  final isAdReady = false.obs;
  final isPromoLoading = false.obs;
  
  final box = GetStorage();
  final apiService = DioApiService();

  // android admob id
  // Test ID (use during development):
  // static const String _adUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Google's test rewarded ad unit
  
  // Production ID (commented out):
  static const String _adUnitId = 'ca-app-pub-6117361441866120/5165063317';

  @override
  void onInit() {
    super.onInit();
    _loadRewardedAd();
  }

  @override
  void onClose() {
    _rewardedAd?.dispose();
    super.onClose();
  }

  void _loadRewardedAd() {
    isAdLoading.value = true;
    dev.log('Loading rewarded ad...', name: 'RewardCentre');

    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          dev.log('Rewarded ad loaded successfully', name: 'RewardCentre');
          _rewardedAd = ad;
          isAdReady.value = true;
          isAdLoading.value = false;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              dev.log('Ad showed full screen content', name: 'RewardCentre');
            },
            onAdDismissedFullScreenContent: (ad) {
              dev.log('Ad dismissed full screen content', name: 'RewardCentre');
              ad.dispose();
              isAdReady.value = false;
              _loadRewardedAd(); // load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              dev.log('Ad failed to show full screen content', name: 'RewardCentre', error: error);
              ad.dispose();
              isAdReady.value = false;
              _loadRewardedAd(); // load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          dev.log('Failed to load rewarded ad', name: 'RewardCentre', error: error);
          isAdLoading.value = false;
          isAdReady.value = false;
          Get.snackbar(
            'Ad Loading Failed',
            'Could not load advertisement. Please try again later.',
            snackPosition: SnackPosition.TOP,
          );
        },
      ),
    );
  }

  void showRewardedAd() {
    if (_rewardedAd == null) {
      dev.log('Rewarded ad is not ready yet', name: 'RewardCentre');
      Get.snackbar(
        'Ad Not Ready',
        isAdLoading.value ? 'Ad is still loading, please wait...' : 'No ad available at the moment.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        dev.log('User earned reward: ${reward.amount} ${reward.type}', name: 'RewardCentre');
        Get.snackbar(
          'Reward Earned!',
          'You earned ${reward.amount} ${reward.type}',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
        // TODO: Add logic to credit user account with reward
      },
    );
  }

  Future<void> tryWinPromoCode() async {
    if (_rewardedAd == null) {
      dev.log('Rewarded ad is not ready for promo code', name: 'RewardCentre');
      Get.snackbar(
        'Ad Not Ready',
        isAdLoading.value ? 'Ad is still loading, please wait...' : 'No ad available at the moment.',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) async {
        dev.log('User watched ad for promo code', name: 'RewardCentre');
        // Call API to get promo code after watching ad
        await _fetchPromoCode();
      },
    );
  }

  Future<void> _fetchPromoCode() async {
    try {
      isPromoLoading.value = true;
      final utilityUrl = box.read('utility_service_url');
      
      if (utilityUrl == null || utilityUrl.isEmpty) {
        Get.snackbar(
          'Error',
          'Service URL not found. Please login again.',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
          snackPosition: SnackPosition.TOP,
        );
        isPromoLoading.value = false;
        return;
      }

      final url = '${utilityUrl}promocode';
      dev.log('Fetching promo code from: $url', name: 'RewardCentre');

      final result = await apiService.getrequest(url);

      result.fold(
        (failure) {
          dev.log('Failed to fetch promo code: ${failure.message}', name: 'RewardCentre');
          isPromoLoading.value = false;
          
          // Show dialog to try again
          _showTryAgainDialog();
        },
        (data) {
          dev.log('Promo code response: ${data.toString()}', name: 'RewardCentre');
          isPromoLoading.value = false;
          
          // Check if user won promo code
          final success = data['success'];
          final promoCode = data['promo_code'];
          final message = data['message'] ?? '';

          if (success == 1 && promoCode != null && promoCode.isNotEmpty) {
            // User won promo code
            _showPromoCodeSuccessDialog(promoCode, message);
          } else {
            // User didn't win, show try again dialog
            _showTryAgainDialog(message: message);
          }
        },
      );
    } catch (e) {
      dev.log('Exception fetching promo code: $e', name: 'RewardCentre');
      isPromoLoading.value = false;
      Get.snackbar(
        'Error',
        'An unexpected error occurred. Please try again.',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _showPromoCodeSuccessDialog(String promoCode, String message) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.card_giftcard,
                  size: 40,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                'Congratulations! 🎉',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Message
              if (message.isNotEmpty)
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              // Promo code container
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your Promo Code',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      promoCode,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTryAgainDialog({String? message}) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.refresh,
                  size: 40,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'Better Luck Next Time!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              // Message
              Text(
                message ?? 'You didn\'t win this time. Watch more advertisements to increase your chances of winning a promo code!',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        tryWinPromoCode();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
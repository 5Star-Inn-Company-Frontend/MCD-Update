import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:developer' as dev;

class RewardCentreModuleController extends GetxController {
  RewardedAd? _rewardedAd;
  final isAdLoading = false.obs;
  final isAdReady = false.obs;

  // android admob id
  // Test ID (use during development):
  // static const String _adUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Google's test rewarded ad unit
  
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
            snackPosition: SnackPosition.BOTTOM,
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
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        dev.log('User earned reward: ${reward.amount} ${reward.type}', name: 'RewardCentre');
        Get.snackbar(
          'Reward Earned!',
          'You earned ${reward.amount} ${reward.type}',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        // TODO: Add logic to credit user account with reward
      },
    );
  }
}
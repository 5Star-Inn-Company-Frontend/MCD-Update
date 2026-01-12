import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:advert/advert.dart';
import 'dart:developer' as dev;

class AdsService {
  static final AdsService _instance = AdsService._internal();
  factory AdsService() => _instance;
  AdsService._internal();

  final _advertPlugin = Advert();
  bool _isInitialized = false;

  static final String bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-6117361441866120/3287545689'
      : 'ca-app-pub-6117361441866120/1488443500';

  static final String rewardVideoUnitId = Platform.isAndroid
      ? 'ca-app-pub-6117361441866120/4412338366'
      : 'ca-app-pub-6117361441866120/2609953488';

  static String interstitialUnitId = Platform.isAndroid
      ? 'ca-app-pub-6117361441866120/8563923098'
      : 'ca-app-pub-6117361441866120/8759030065';

  static String nativeAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-6117361441866120/7557970286'
      : 'ca-app-pub-6117361441866120/5123378631';

  static String rewardInterstitialUnitId = Platform.isAndroid
      ? 'ca-app-pub-6117361441866120/4577116553'
      : 'ca-app-pub-6117361441866120/6040874481';

  Future<void> initialize({bool testMode = false}) async {
    if (_isInitialized) {
      dev.log('Ads already initialized');
      return;
    }
    Googlemodel googlemodel = Googlemodel()
      ..bannerAdUnitId = [bannerAdUnitId]
    // ..nativeadUnitId = _nativeadUnitId
      ..rewardedInterstitialAdUnitId = [rewardInterstitialUnitId]
      ..rewardedAdUnitId = [rewardVideoUnitId]
      // ..spinAndWin = spinandwinUnitId
      ..interstitialAdUnitId = [interstitialUnitId];
    try {
      await _advertPlugin.initialize(testmode: testMode, adsmodel: Adsmodel(googlemodel: googlemodel),);
      _isInitialized = true;
      dev.log('Ads initialized successfully');
    } catch (e) {
      dev.log('Error initializing ads: $e');
    }
  }

  void showBannerAd() {
    if (!_isInitialized) {
      dev.log('Error: Ads not initialized');
      return;
    }
    
    try {
      _advertPlugin.adsProv.showBannerAd();
      dev.log('Banner ad shown');
    } catch (e) {
      dev.log('Error showing banner ad: $e');
    }
  }

  void showInterstitialAd() {
    if (!_isInitialized) {
      dev.log('Error: Ads not initialized');
      return;
    }

    try {
      _advertPlugin.adsProv.showInterstitialAd();
      dev.log('Interstitial ad shown');
    } catch (e) {
      dev.log('Error showing interstitial ad: $e');
    }
  }

  Future<bool> showRewardedAd({
    VoidCallback? onRewarded,
    Map<String, String>? customData,
  }) async {
    if (!_isInitialized) {
      dev.log('Error: Ads not initialized');
      return false;
    }

    try {
      final completer = Completer<void>();
      final defaultCustomData = customData ?? {"username": "", "platform": "", "type": ""};

      final response = await _advertPlugin.adsProv.showRewardedAd(() {
        if (!completer.isCompleted) {
          completer.complete();
          onRewarded?.call();
        }
      }, defaultCustomData);

      if (response.status) {
        await completer.future;
        dev.log('Rewarded ad completed successfully');
        return true;
      } else {
        dev.log('Error: Rewarded ad failed to show');
        return false;
      }
    } catch (e) {
      dev.log('Error showing rewarded ad: $e');
      return false;
    }
  }

  Future<bool> showMultipleRewardedAds({
    required int maxAds,
    Map<String, String>? customData,
    Function(int)? onAdCompleted,
  }) async {
    if (!_isInitialized) {
      dev.log('Ads not initialized yet, initializing now...');
      await initialize(testMode: false);
      
      if (!_isInitialized) {
        dev.log('Error: Failed to initialize ads');
        return false;
      }
    }

    try {
      final defaultCustomData = customData ?? {"username": "", "platform": "", "type": ""};
      int completedAds = 0;

      for (int i = 0; i < maxAds; i++) {
        final completer = Completer<void>();

        final response = await _advertPlugin.adsProv.showRewardedAd(() {
          if (!completer.isCompleted) {
            completer.complete();
          }
        }, defaultCustomData);

        if (response.status) {
          await completer.future;
          completedAds++;
          onAdCompleted?.call(completedAds);
          dev.log('Completed ad $completedAds/$maxAds');
        } else {
          dev.log('Error: Failed to show ad ${i + 1}. Stopping.');
          break;
        }
      }

      return completedAds == maxAds;
    } catch (e) {
      dev.log('Error showing multiple rewarded ads: $e');
      return false;
    }
  }

  bool get isInitialized => _isInitialized;
}

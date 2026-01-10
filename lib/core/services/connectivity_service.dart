import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  
  final isConnected = true.obs;
  final connectionType = ConnectivityResult.none.obs;
  final showNoConnectionBanner = false.obs;
  
  static ConnectivityService get to => Get.find<ConnectivityService>();

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      dev.log('Failed to get connectivity.', name: 'ConnectivityService', error: e);
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) async {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    connectionType.value = result;
    
    // Check if actually connected to internet
    if (result != ConnectivityResult.none) {
      final hasInternet = await checkInternetConnection();
      final wasDisconnected = !isConnected.value;
      isConnected.value = hasInternet;
      
      if (hasInternet) {
        _hideNoConnectionBanner();
        dev.log('Internet connection restored: $result', name: 'ConnectivityService');
        // Show success snackbar when connection is restored (only if was previously disconnected)
        if (wasDisconnected && Get.context != null) {
          try {
            Get.closeAllSnackbars();
          } catch (e) {
            dev.log('Error closing snackbars', name: 'ConnectivityService', error: e);
          }
          Get.snackbar(
            'Connection Restored',
            'You are back online',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green.shade600,
            colorText: Colors.white,
            icon: const Icon(Icons.wifi, color: Colors.white),
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(10),
          );
        }
      } else {
        _showNoConnectionBanner();
        dev.log('Connected to network but no internet access', name: 'ConnectivityService');
      }
    } else {
      isConnected.value = false;
      _showNoConnectionBanner();
      dev.log('No internet connection', name: 'ConnectivityService');
    }
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      dev.log('Error checking internet connection', name: 'ConnectivityService', error: e);
      return false;
    }
  }

  void _showNoConnectionBanner() {
    if (showNoConnectionBanner.value) return; // Already showing

    showNoConnectionBanner.value = true;

    // Show snackbar notification
    try {
      Get.closeAllSnackbars();
    } catch (e) {
      dev.log('Error closing snackbars', name: 'ConnectivityService', error: e);
    }
    Get.snackbar(
      'No Internet Connection',
      'Please check your connection',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
      duration: const Duration(days: 1), // Keep showing until connection restored
      isDismissible: false,
      margin: const EdgeInsets.all(10),
      mainButton: TextButton.icon(
        onPressed: () async {
          final hasConnection = await checkInternetConnection();
          if (hasConnection) {
            showNoConnectionBanner.value = false;
            // Defer closing snackbar to next frame to avoid race condition
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                Get.closeAllSnackbars();
              } catch (e) {
                dev.log('Error closing snackbars', name: 'ConnectivityService', error: e);
              }
              Get.snackbar(
                'Connection Restored',
                'You are back online',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green.shade600,
                colorText: Colors.white,
                icon: const Icon(Icons.wifi, color: Colors.white),
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(10),
              );
            });
          }
        },
        icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
        label: const Text('Retry', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _hideNoConnectionBanner() {
    if (!showNoConnectionBanner.value) return; // Already hidden
    
    showNoConnectionBanner.value = false;
    try {
      Get.closeAllSnackbars();
    } catch (e) {
      dev.log('Error closing snackbars', name: 'ConnectivityService', error: e);
    }
  }

  Future<bool> verifyConnection() async {
    final results = await _connectivity.checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    
    if (result == ConnectivityResult.none) {
      isConnected.value = false;
      _showNoConnectionAlert();
      return false;
    }
    
    final hasInternet = await checkInternetConnection();
    isConnected.value = hasInternet;
    
    if (!hasInternet) {
      _showNoConnectionAlert();
      return false;
    }
    
    return true;
  }

  void _showNoConnectionAlert() {
    Get.snackbar(
      'No Internet Connection',
      'Please check your internet connection and try again.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      icon: const Icon(Icons.wifi_off, color: Colors.white),
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
    );
  }

  String getConnectionTypeString() {
    switch (connectionType.value) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'No Connection';
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/home_screen_module/home_screen_controller.dart';
import 'dart:developer' as dev;

class MyQrcodeModuleController extends GetxController {
  final GetStorage _storage = GetStorage();

  // User data observables
  final _username = ''.obs;
  String get username => _username.value;

  final _email = ''.obs;
  String get email => _email.value;

  // QR data - embed username
  String get qrData => username;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    try {
      // Try to get data from HomeScreenController first
      final homeController = Get.find<HomeScreenController>();
      if (homeController.dashboardData != null) {
        _username.value = homeController.dashboardData.user.userName ?? 'User';
        _email.value = homeController.dashboardData.user.email ?? 'user@example.com';
        dev.log('Loaded user data from dashboard - Username: ${_username.value}, Email: ${_email.value}');
      } else {
        // Fallback to storage
        _username.value = _storage.read('username') ?? 'User';
        _email.value = _storage.read('email') ?? 'user@example.com';
        dev.log('Dashboard data not available, loaded from storage');
      }
    } catch (e) {
      dev.log('Error loading user data: $e');
      // Final fallback to storage
      _username.value = _storage.read('username') ?? 'User';
      _email.value = _storage.read('email') ?? 'user@example.com';
    }
  }

  // Save QR code functionality
  Future<void> saveQRCode() async {
    try {
      // TODO: Implement QR code saving logic
      Get.snackbar(
        'Success',
        'QR Code saved successfully',
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save QR code',
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}
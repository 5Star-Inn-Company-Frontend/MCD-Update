import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyQrcodeModuleController extends GetxController {
  final GetStorage _storage = GetStorage();

  // User data observables
  final _username = ''.obs;
  String get username => _username.value;

  final _email = ''.obs;
  String get email => _email.value;

  // QR data
  String get qrData => username; // or any unique identifier

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    // Load user data from storage
    _username.value = _storage.read('username') ?? 'User';
    _email.value = _storage.read('email') ?? 'user@example.com';
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
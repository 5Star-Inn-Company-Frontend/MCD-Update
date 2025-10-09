import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricHelper {
  final LocalAuthentication _auth = LocalAuthentication();
  final GetStorage _storage = GetStorage();

  Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Use biometrics to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable || e.code == auth_error.notEnrolled) {
        return false;
      }
      rethrow;
    }
  }

  // Save credentials securely in GetStorage (optionally encrypted later)
  Future<void> saveCredentials(String username, String password) async {
    await _storage.write('bio_username', username);
    await _storage.write('bio_password', password);
  }

  // Retrieve credentials
  Map<String, String?> getSavedCredentials() {
    return {
      'username': _storage.read('bio_username'),
      'password': _storage.read('bio_password'),
    };
  }

  // Clear saved credentials
  Future<void> clearCredentials() async {
    await _storage.remove('bio_username');
    await _storage.remove('bio_password');
  }
}

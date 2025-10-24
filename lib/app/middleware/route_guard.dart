import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';

/// Helper class to check if number verification is needed
class RouteGuardHelper {
  static bool needsVerification() {
    final args = Get.arguments;
    if (args is Map && args.containsKey('verifiedNumber')) {
      return false;
    }
    return true;
  }

  static void navigateToVerification(String targetRoute) {
    Get.toNamed(
      Routes.NUMBER_VERIFICATION_MODULE,
      arguments: {'redirectTo': targetRoute},
    );
  }
}
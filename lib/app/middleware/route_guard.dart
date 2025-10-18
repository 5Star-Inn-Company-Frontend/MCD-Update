import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';

/// This middleware forces the user to the number verification screen
/// before accessing a protected route.
class ForceNumberVerificationMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Check if we're coming from a verified number (via arguments)
    final args = Get.arguments;
    if (args is Map && args.containsKey('verifiedNumber')) {
      // Number already verified, allow access
      return null;
    }
    
    // Prevent infinite loop - if already on verification page, don't redirect
    if (Get.currentRoute == Routes.NUMBER_VERIFICATION_MODULE) {
      return null;
    }
    
    // Redirect to verification page with the intended route
    return RouteSettings(
      name: Routes.NUMBER_VERIFICATION_MODULE,
      arguments: {'redirectTo': route},
    );
  }
}
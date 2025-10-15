import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart'; // Make sure this import is correct

/// This middleware forces the user to the number verification screen
/// before accessing a protected route.
class ForceNumberVerificationMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Always redirect to the verification page.
    // Pass the original intended route (e.g., /airtime) as an argument
    // so we know where to navigate after successful verification.
    return RouteSettings(
      name: Routes.NUMBER_VERIFICATION_MODULE,
      arguments: {'redirectTo': route},
    );
  }
}
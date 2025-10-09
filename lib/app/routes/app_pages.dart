import '../../app/modules/verify_otp_module/verify_otp_page.dart';
import '../../app/modules/verify_otp_module/verify_otp_bindings.dart';
import '../../app/modules/new_device_verify_module/new_device_verify_page.dart';
import '../../app/modules/new_device_verify_module/new_device_verify_bindings.dart';
import '../../app/modules/pin_verify_module/pin_verify_page.dart';
import '../../app/modules/pin_verify_module/pin_verify_bindings.dart';
import '../../app/modules/reset_password_module/reset_password_page.dart';
import '../../app/modules/reset_password_module/reset_password_bindings.dart';
import '../../app/modules/home_navigation_module/home_navigation_page.dart';
import '../../app/modules/home_navigation_module/home_navigation_bindings.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/createaccount_module/createaccount_bindings.dart';
import 'package:mcd/app/modules/createaccount_module/createaccount_page.dart';
import 'package:mcd/app/modules/login_screen_module/login_screen_bindings.dart';
import 'package:mcd/app/modules/login_screen_module/login_screen_page.dart';

import '../../app/modules/splash_screen_module/splash_screen_bindings.dart';
import '../../app/modules/splash_screen_module/splash_screen_page.dart';

part './app_routes.dart';
/**
 * GetX Generator - fb.com/htngu.99
 * */

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SPLASH_SCREEN,
      page: () => SplashScreenPage(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: Routes.LOGIN_SCREEN,
      page: () => LoginScreenPage(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: Routes.CREATEACCOUNT,
      page: () => createaccountPage(),
      binding: createaccountBinding(),
    ),
    GetPage(
      name: Routes.HOME_NAVIGATION,
      page: () => HomeNavigationPage(),
      binding: HomeNavigationBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD,
      page: () => ResetPasswordPage(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: Routes.PIN_VERIFY,
      page: () => PinVerifyPage(),
      binding: PinVerifyBinding(),
    ),
    GetPage(
      name: Routes.NEW_DEVICE_VERIFY,
      page: () => NewDeviceVerifyPage(),
      binding: NewDeviceVerifyBinding(),
    ),
    GetPage(
      name: Routes.VERIFY_OTP,
      page: () => VerifyOtpPage(),
      binding: VerifyOtpBinding(),
    ),
  ];
}

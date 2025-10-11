import '../../app/modules/more_module_module/more_module_page.dart';
import '../../app/modules/more_module_module/more_module_bindings.dart';
import '../../app/modules/assistant_screen_module/assistant_screen_page.dart';
import '../../app/modules/assistant_screen_module/assistant_screen_bindings.dart';
import '../../app/modules/shop_screen_module/shop_screen_page.dart';
import '../../app/modules/shop_screen_module/shop_screen_bindings.dart';
import '../../app/modules/history_screen_module/history_screen_page.dart';
import '../../app/modules/history_screen_module/history_screen_bindings.dart';
import '../../app/modules/home_screen_module/home_screen_page.dart';
import '../../app/modules/home_screen_module/home_screen_bindings.dart';
import 'package:mcd/app/modules/account_info_module/account_info_module_bindings.dart';
import 'package:mcd/app/modules/account_info_module/account_info_module_page.dart';
import 'package:mcd/app/modules/more_module/more_module_bindings.dart';
import 'package:mcd/app/modules/more_module/more_module_page.dart' hide MoreModulePage;
import 'package:mcd/app/modules/reset_password_module/change_reset_pwd_screen.dart';
import 'package:mcd/app/modules/reset_password_module/verify_reset_pwd_otp_screeen.dart';
import 'package:mcd/app/modules/settings_module/settings_module_bindings.dart';
import 'package:mcd/app/modules/settings_module/settings_module_page.dart';
import 'package:mcd/app/modules/splash_screen_module/splash_screen_bindings.dart';
import 'package:mcd/app/modules/splash_screen_module/splash_screen_controller.dart';
import 'package:mcd/core/import/imports.dart';

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

// import '../../app/modules/splash_screen_module/splash_screen_bindings.dart';
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
      name: Routes.VERIFY_RESET_PASSWORD_OTP,
      page: () => VerifyResetPwdOtpPage(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: Routes.CHANGE_RESET_PASSWORD,
      page: () => ChangeResetPwdPage(),
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
    GetPage(
      name: Routes.MORE,
      page: () => MoreModulePage(),
      binding: MoreModuleBindings(),
    ),
    GetPage(
      name: Routes.ACCOUNT_INFO,
      page: () => AccountInfoModulePage(),
      binding: AccountInfoModuleBindings(),
    ),
    GetPage(
      name: Routes.SETTINGS_SCREEN,
      page: () => SettingsModulePage(),
      binding: SettingsModuleBindings(),
    ),
    GetPage(
      name: Routes.HOME_SCREEN,
      page: () => HomeScreenPage(),
      binding: HomeScreenBinding(),
    ),
    GetPage(
      name: Routes.HISTORY_SCREEN,
      page: () => HistoryScreenPage(),
      binding: HistoryScreenBinding(),
    ),
    GetPage(
      name: Routes.SHOP_SCREEN,
      page: () => ShopScreenPage(),
      binding: ShopScreenBinding(),
    ),
    GetPage(
      name: Routes.ASSISTANT_SCREEN,
      page: () => AssistantScreenPage(),
      binding: AssistantScreenBinding(),
    ),
    GetPage(
      name: Routes.MORE_MODULE,
      page: () => MoreModulePage(),
      binding: MoreModuleBinding(),
    ),
  ];
}

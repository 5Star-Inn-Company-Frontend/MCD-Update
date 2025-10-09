import 'package:get/get.dart';
import 'package:mcd/features/auth/presentation/views/auth_screen.dart';
import 'package:mcd/features/auth/presentation/views/biometrrics.dart';
import 'package:mcd/features/auth/presentation/views/change_reset_password_screen.dart';
import 'package:mcd/features/auth/presentation/views/create_account.screen.dart';
import 'package:mcd/features/auth/presentation/views/login_screen.dart';
import 'package:mcd/features/auth/presentation/views/new_device_verify_screen.dart';
import 'package:mcd/features/auth/presentation/views/pin_verify_screen.dart';
import 'package:mcd/features/auth/presentation/views/reset_password_otp.dart';
// import 'package:mcd/features/auth/presentation/views/reset_password_screen.dart';
import 'package:mcd/features/auth/presentation/views/two_fa_screen.dart';
import 'package:mcd/features/auth/presentation/views/verify_otp_screen.dart';
import 'package:mcd/features/home/presentation/views/home_navigation.dart';
import 'package:mcd/features/home/presentation/views/kyc_update_screen.dart';
import 'package:mcd/features/onboarding/presentation/views/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.authenticate,
      page: () => const Authenticate(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(toggleView: (_) {}),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => CreateAccount(toggleView: (_) {}),
    ),
    GetPage(
      name: AppRoutes.verifyOtp,
      page: () => const VerifyOtpScreen(email: '',),
    ),
    GetPage(
      name: AppRoutes.homenav,
      page: () => HomeNavigation()
    ),
    GetPage(
      name: AppRoutes.verify2FA,
      page: () => TwoFAScreen(email: '',)
    ),
    GetPage(
      name: AppRoutes.pinVerify,
      page: () => PinVerifyScreen()
    ),
    GetPage(
      name: AppRoutes.newDeviceVerify,
      page: () => NewDeviceVerifyScreen()
    ),
    GetPage(
      name: AppRoutes.verifyResetPasswordOtp,
      page: () => VerifyResetOtpScreen()
    ),
    GetPage(
      name: AppRoutes.changeResetPassword,
      page: () => ChangeResetPasswordScreen()
    ),
    GetPage(
      name: AppRoutes.kycUpdate,
      page: () => KycUpdateScreen()
    ),
    GetPage(
      name: AppRoutes.biometricLogin,
      page: () => SetFingerPrint()
    ),
  ];
}

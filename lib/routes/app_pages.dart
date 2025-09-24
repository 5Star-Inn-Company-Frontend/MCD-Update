import 'package:get/get.dart';
import 'package:mcd/features/auth/presentation/views/auth_screen.dart';
import 'package:mcd/features/auth/presentation/views/create_account.screen.dart';
import 'package:mcd/features/auth/presentation/views/login_screen.dart';
import 'package:mcd/features/auth/presentation/views/two_fa_screen.dart';
import 'package:mcd/features/auth/presentation/views/verify_otp_screen.dart';
import 'package:mcd/features/home/presentation/views/home_navigation.dart';
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
  ];
}

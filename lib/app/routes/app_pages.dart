import 'package:mcd/app/modules/add_money_module/add_money_module_bindings.dart';
import 'package:mcd/app/modules/add_money_module/add_money_module_page.dart';
import 'package:mcd/app/modules/airtime_module/airtime_module_bindings.dart';
import 'package:mcd/app/modules/airtime_module/airtime_module_page.dart';
import 'package:mcd/app/modules/betting_module/betting_module_bindings.dart';
import 'package:mcd/app/modules/betting_module/betting_module_page.dart';
import 'package:mcd/app/modules/cable_module/cable_module_bindings.dart';
import 'package:mcd/app/modules/cable_module/cable_module_page.dart';
import 'package:mcd/app/modules/cable_payout_module/cable_payout_module_bindings.dart';
import 'package:mcd/app/modules/cable_payout_module/cable_payout_module_page.dart';
import 'package:mcd/app/modules/cable_transaction_module/cable_transaction_module_bindings.dart';
import 'package:mcd/app/modules/cable_transaction_module/cable_transaction_module_page.dart';
import 'package:mcd/app/modules/data_module/data_module_bindings.dart';
import 'package:mcd/app/modules/data_module/data_module_page.dart';
import 'package:mcd/app/modules/electricity_module/electricity_module_bindings.dart';
import 'package:mcd/app/modules/electricity_module/electricity_module_page.dart';
import 'package:mcd/app/modules/electricity_payout_module/electricity_payout_module_bindings.dart';
import 'package:mcd/app/modules/electricity_payout_module/electricity_payout_module_page.dart';
import 'package:mcd/app/modules/electricity_transaction_module/electricity_transaction_module_bindings.dart';
import 'package:mcd/app/modules/electricity_transaction_module/electricity_transaction_module_page.dart';
import 'package:mcd/app/modules/jamb_module/jamb_module_bindings.dart';
import 'package:mcd/app/modules/jamb_module/jamb_module_page.dart';
import 'package:mcd/app/modules/jamb_verfy_account_module/jamb_verfy_account_module_bindings.dart';
import 'package:mcd/app/modules/jamb_verfy_account_module/jamb_verfy_account_module_page.dart';
import 'package:mcd/app/modules/jamb_payment_module/jamb_payment_module_bindings.dart';
import 'package:mcd/app/modules/jamb_payment_module/jamb_payment_module_page.dart';
import 'package:mcd/app/modules/reward_centre_module/reward_centre_module_bindings.dart';
import 'package:mcd/app/modules/reward_centre_module/reward_centre_module_page.dart';
import 'package:mcd/app/modules/giveaway_module/giveaway_module_bindings.dart';
import 'package:mcd/app/modules/giveaway_module/giveaway_module_page.dart';
import 'package:mcd/app/modules/virtual_card_home/virtual_card_home_bindings.dart';
import 'package:mcd/app/modules/virtual_card_home/virtual_card_home_page.dart';
import 'package:mcd/app/modules/virtual_card_details/virtual_card_details_bindings.dart';
import 'package:mcd/app/modules/virtual_card_details/virtual_card_details_page.dart';
import 'package:mcd/app/modules/virtual_card_request/virtual_card_request_bindings.dart';
import 'package:mcd/app/modules/virtual_card_request/virtual_card_request_page.dart';
import 'package:mcd/app/modules/virtual_card_application/virtual_card_application_bindings.dart';
import 'package:mcd/app/modules/virtual_card_application/virtual_card_application_page.dart';
import 'package:mcd/app/modules/nin_validation_module/nin_validation_module_bindings.dart';
import 'package:mcd/app/modules/nin_validation_module/nin_validation_module_page.dart';
import 'package:mcd/app/modules/result_checker_module/result_checker_module_bindings.dart';
import 'package:mcd/app/modules/result_checker_module/result_checker_module_page.dart';
import 'package:mcd/app/modules/transaction_detail_module/transaction_detail_module_bindings.dart';
import 'package:mcd/app/modules/transaction_detail_module/transaction_detail_module_page.dart';
import 'package:mcd/app/modules/plans_module/plans_module_bindings.dart';
import 'package:mcd/app/modules/plans_module/plans_module_page.dart';
import 'package:mcd/app/modules/notification_module/notification_module_bindings.dart';
import 'package:mcd/app/modules/notification_module/notification_module_page.dart';
import 'package:mcd/app/modules/leaderboard_module/leaderboard_module_bindings.dart';
import 'package:mcd/app/modules/leaderboard_module/leaderboard_module_page.dart';

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
import 'package:mcd/app/modules/more_module/more_module_page.dart';
import 'package:mcd/app/modules/reset_password_module/change_reset_pwd_screen.dart';
import 'package:mcd/app/modules/reset_password_module/verify_reset_pwd_otp_screeen.dart';
import 'package:mcd/app/modules/settings_module/settings_module_bindings.dart';
import 'package:mcd/app/modules/settings_module/settings_module_page.dart';
import 'package:mcd/app/modules/splash_screen_module/splash_screen_bindings.dart';
import 'package:mcd/core/import/imports.dart';

import '../../app/modules/verify_otp_module/verify_otp_page.dart';
import '../../app/modules/verify_otp_module/verify_otp_bindings.dart';
import '../../app/modules/new_device_verify_module/new_device_verify_page.dart';
import '../../app/modules/new_device_verify_module/new_device_verify_bindings.dart';
import '../../app/modules/pin_verify_module/pin_verify_page.dart';
import '../../app/modules/pin_verify_module/pin_verify_bindings.dart';
import '../../app/modules/reset_password_module/reset_password_page.dart';
import '../../app/modules/reset_password_module/reset_password_bindings.dart';
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
      binding: MoreModuleBindings(),
    ),
    GetPage(
      name: Routes.AIRTIME_MODULE,
      page: () => AirtimeModulePage(),
      binding: AirtimeModuleBindings(),
    ),
    GetPage(
      name: Routes.TRANSACTION_DETAIL_MODULE,
      page: () => TransactionDetailModulePage(),
      binding: TransactionDetailModuleBindings(),
    ),
    GetPage(
      name: Routes.DATA_MODULE,
      page: () => DataModulePage(),
      binding: DataModuleBindings(),
    ),
    GetPage(
      name: Routes.BETTING_MODULE,
      page: () => BettingModulePage(),
      binding: BettingModuleBindings()
    ),
    GetPage(
      name: Routes.ELECTRICITY_MODULE,
      page: () => ElectricityModulePage(),
      binding: ElectricityModuleBindings()
    ),
    GetPage(
      name: Routes.ELECTRICITY_PAYOUT_MODULE,
      page: () => ElectricityPayoutPage(),
      binding: ElectricityPayoutModuleBindings()
    ),
    GetPage(
      name: Routes.ELECTRICITY_TRANSACTION_MODULE,
      page: () => ElectricityTransactionPage(),
      binding: ElectricityTransactionModuleBindings()
    ),
    GetPage(
      name: Routes.CABLE_MODULE,
      page: () => CableModulePage(),
      binding: CableModuleBindings()
    ),
    GetPage(
      name: Routes.CABLE_PAYOUT_MODULE,
      page: () => CablePayoutPage(),
      binding: CablePayoutModuleBindings()
    ),
    GetPage(
      name: Routes.CABLE_TRANSACTION_MODULE,
      page: () => CableTransactionPage(),
      binding: CableTransactionModuleBindings()
    ),
    GetPage(
      name: Routes.NIN_VALIDATION_MODULE,
      page: () => NinValidationModulePage(),
      binding: NinValidationModuleBindings()
    ),
    GetPage(
      name: Routes.ADD_MONEY_MODULE,
      page: () => AddMoneyModulePage(),
      binding: AddMoneyModuleBindings()
    ),
    GetPage(
      name: Routes.RESULT_CHECKER_MODULE,
      page: () => const ResultCheckerModulePage(),
      binding: ResultCheckerModuleBindings()
    ),
    GetPage(
      name: Routes.JAMB_MODULE,
      page: () => const JambModulePage(),
      binding: JambModuleBindings()
    ),
    GetPage(
      name: Routes.JAMB_VERIFY_ACCOUNT_MODULE,
      page: () => const JambVerfyAccountModulePage(),
      binding: JambVerfyAccountModuleBindings()
    ),
    GetPage(
      name: Routes.JAMB_PAYMENT_MODULE,
      page: () => const JambPaymentModulePage(),
      binding: JambPaymentModuleBindings()
    ),
    GetPage(
      name: Routes.REWARD_CENTRE_MODULE,
      page: () => const RewardCentreModulePage(),
      binding: RewardCentreModuleBindings()
    ),
    GetPage(
      name: Routes.GIVEAWAY_MODULE,
      page: () => const GiveawayModulePage(),
      binding: GiveawayModuleBindings()
    ),
    GetPage(
      name: Routes.VIRTUAL_CARD_HOME,
      page: () => const VirtualCardHomePage(),
      binding: VirtualCardHomeBindings()
    ),
    GetPage(
      name: Routes.VIRTUAL_CARD_DETAILS,
      page: () => const VirtualCardDetailsPage(),
      binding: VirtualCardDetailsBindings()
    ),
    GetPage(
      name: Routes.VIRTUAL_CARD_REQUEST,
      page: () => const VirtualCardRequestPage(),
      binding: VirtualCardRequestBindings()
    ),
    GetPage(
      name: Routes.VIRTUAL_CARD_APPLICATION,
      page: () => const VirtualCardApplicationPage(),
      binding: VirtualCardApplicationBindings()
    ),
    GetPage(
      name: Routes.PLANS_MODULE,
      page: () => const PlansModulePage(),
      binding: PlansModuleBindings()
    ),
    GetPage(
      name: Routes.NOTIFICATION_MODULE,
      page: () => const NotificationModulePage(),
      binding: NotificationModuleBindings()
    ),
    GetPage(
      name: Routes.LEADERBOARD_MODULE,
      page: () => const LeaderboardModulePage(),
      binding: LeaderboardModuleBindings()
    ),
  ];
}

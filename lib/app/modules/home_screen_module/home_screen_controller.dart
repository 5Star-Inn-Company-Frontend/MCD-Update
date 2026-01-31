import 'dart:convert';
import 'dart:developer' as dev;

import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/modules/home_screen_module/model/button_model.dart';
import 'package:mcd/app/modules/home_screen_module/model/dashboard_model.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/mixins/service_availability_mixin.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_api_service.dart';
import 'package:mcd/core/services/ads_service.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class HomeScreenController extends GetxController
    with ServiceAvailabilityMixin {
  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final _actionButtonz = <ButtonModel>[].obs;
  List<ButtonModel> get actionButtonz => _actionButtonz;

  final _dashboardData = Rxn<DashboardModel>();
  set dashboardData(value) => _dashboardData.value = value;
  get dashboardData => _dashboardData.value;

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _errorMessage = ''.obs;
  set errorMessage(value) => _errorMessage.value = value;
  get errorMessage => _errorMessage.value;

  final _gmBalance = '0'.obs;
  set gmBalance(value) => _gmBalance.value = value;
  get gmBalance => _gmBalance.value;

  final apiService = DioApiService();
  final box = GetStorage();

  @override
  void onInit() {
    dev.log("HomeScreenController initialized");
    fetchDashboard();
    fetchGMBalance();
    fetchservicestatus();
    super.onInit();
  }

  void updateActionButtons(Map<String, dynamic> services) {
    final allButtons = <ButtonModel>[
      ButtonModel(
          icon: AppAsset.airtime, text: "Airtime", link: Routes.AIRTIME_MODULE),
      ButtonModel(
          icon: AppAsset.internet,
          text: "Internet Data",
          link: Routes.DATA_MODULE),
      ButtonModel(
          icon: AppAsset.tv, text: "Cable Tv", link: Routes.CABLE_MODULE),
      ButtonModel(
          icon: AppAsset.electricity,
          text: "Electricity",
          link: Routes.ELECTRICITY_MODULE),
      ButtonModel(
          icon: AppAsset.ball, text: "Betting", link: Routes.BETTING_MODULE),
      ButtonModel(icon: AppAsset.list, text: "Epins", link: "epin"),
      ButtonModel(
          icon: AppAsset.money,
          text: "Airtime to cash",
          link: Routes.A2C_MODULE),
      ButtonModel(
          icon: AppAsset.docSearch,
          text: "Result checker",
          link: Routes.RESULT_CHECKER_MODULE),
      ButtonModel(icon: AppAsset.posIcon, text: "POS", link: Routes.POS_HOME),
      ButtonModel(
          icon: AppAsset.nin,
          text: "NIN Validation",
          link: Routes.NIN_VALIDATION_MODULE),
      ButtonModel(
          icon: AppAsset.gift,
          text: "Reward Centre",
          link: Routes.REWARD_CENTRE_MODULE),
      ButtonModel(icon: AppAsset.service, text: "Mega Bulk Service", link: ""),
    ];

    _actionButtonz.assignAll(allButtons.where((button) {
      final serviceKey = getServiceKey(button.text, button.link);
      return services.containsKey(serviceKey) && services[serviceKey] == "1";
    }).toList());
  }

  @override
  void onReady() {
    super.onReady();
    dev.log(
        "HomeScreenController ready, dashboardData: ${dashboardData != null ? 'loaded' : 'null'}");

    // Show banner ad
    AdsService().showBannerAd();
  }

  @override
  void onClose() {}

  Future<void> fetchDashboard({bool force = false}) async {
    dev.log(
        "fetchDashboard called, force: $force, current data: ${dashboardData != null ? 'exists' : 'null'}");

    // Always fetch if data is null
    if (dashboardData != null && !force) {
      dev.log("Dashboard already loaded, skipping fetch");
      return;
    }

    isLoading = true;
    errorMessage = "";
    dev.log("Starting dashboard fetch...");

    final result =
        await apiService.getrequest("${ApiConstants.authUrlV2}/dashboard");

    result.fold(
      (failure) {
        errorMessage = failure.message;
        dev.log("Dashboard fetch failed: ${failure.message}");
        Get.snackbar("Error", failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor);
      },
      (data) async {
        dev.log("Dashboard fetch success: ${data.toString()}");
        dashboardData = DashboardModel.fromJson(data);
        dev.log(
            "Dashboard model created - User: ${dashboardData?.user.userName}, Balance: ${dashboardData?.balance.wallet}");

        // save username e.g excade001
        await box.write(
            'biometric_username_real', dashboardData?.user.userName ?? 'MCD');
        dev.log(
            "Biometric username updated in storage: ${box.read('biometric_username_real')}");

        await box.write('user_email', dashboardData?.user.email ?? '');
        dev.log("User email updated in storage: ${box.read('user_email')}");

        if (force) {
          // Get.snackbar("Updated", "Dashboard refreshed", backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
          dev.log("Dashboard refreshed successfully");
        }
      },
    );

    isLoading = false;
  }

  Future<void> refreshDashboard() async {
    await Future.wait([
      fetchDashboard(force: true),
      fetchGMBalance(),
      fetchservicestatus(),
    ]);
  }

  Future<void> fetchGMBalance() async {
    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'HomeScreen', error: 'URL missing');
      return;
    }

    final result =
        await apiService.getrequest('${transactionUrl}gmtransactions');

    result.fold(
      (failure) {
        dev.log('GM balance fetch failed: ${failure.message}',
            name: 'HomeScreen');
      },
      (data) {
        dev.log('GM balance response: $data', name: 'HomeScreen');

        if (data['wallet'] != null) {
          gmBalance = data['wallet'].toString();
          dev.log('GM balance updated to: ₦$gmBalance', name: 'HomeScreen');
        } else {
          dev.log('Wallet balance not found in response', name: 'HomeScreen');
        }
      },
    );
  }

  Future<void> fetchservicestatus() async {
    var storageresult = box.read('serviceenablingdata');
    if (storageresult != null) {
      var data = jsonDecode(storageresult);
      if (data != null) {
        updateActionButtons(data);
      }
    }
    final transactionUrl = box.read('transaction_service_url');
    if (transactionUrl == null) {
      dev.log('Transaction URL not found',
          name: 'HomeScreen', error: 'URL missing');
      return;
    }

    final result = await apiService.getrequest('${transactionUrl}services');

    result.fold(
      (failure) {
        dev.log('Service status fetch failed: ${failure.message}',
            name: 'HomeScreen');
      },
      (data) async {
        dev.log('Service status response: ${data['data']}', name: 'HomeScreen');
        await box.write('serviceenablingdata', jsonEncode(data['data']));
        if (data['data']['services'] != null) {
          updateActionButtons(data['data']['services']);
        }
      },
    );
  }

  /// Get service key for API checking based on button text/link
  String getServiceKey(String buttonText, String? link) {
    // Map button text/link to API service keys
    if (buttonText.toLowerCase().contains("airtime")) {
      if (buttonText.toLowerCase().contains("cash")) {
        return "airtimeconverter";
      }
      return "airtime";
    } else if (buttonText.toLowerCase().contains("internet") ||
        buttonText.toLowerCase().contains("data")) {
      return "data";
    } else if (buttonText.toLowerCase().contains("cable") ||
        buttonText.toLowerCase().contains("tv")) {
      return "paytv";
    } else if (buttonText.toLowerCase().contains("electricity")) {
      return "electricity";
    } else if (buttonText.toLowerCase().contains("betting")) {
      return "betting";
    } else if (buttonText.toLowerCase().contains("epin") || link == "epin") {
      return "rechargecard";
    } else if (buttonText.toLowerCase().contains("result")) {
      return "resultchecker";
    } else if (buttonText.toLowerCase().contains("nin")) {
      return "nin_validation";
    } else if (link == Routes.POS_HOME) {
      return "virtual_card";
    } else if (buttonText.toLowerCase().contains("reward")) {
      // Check for spin win, giveaway, etc.
      return "spinwin"; // Default to spinwin for reward centre
    }
    return "";
  }

  /// Handle service button tap with availability check
  Future<bool> handleServiceNavigation(ButtonModel button) async {
    final serviceKey = getServiceKey(button.text, button.link);

    // If no service key mapping, allow navigation (e.g., Mega Bulk Service)
    if (serviceKey.isEmpty) {
      return true;
    }

    // Check service availability
    return await checkAndNavigate(
      serviceKey,
      serviceName: button.text,
    );
  }
}

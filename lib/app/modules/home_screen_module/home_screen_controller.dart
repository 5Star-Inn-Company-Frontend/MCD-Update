import 'dart:developer' as dev;

import 'package:mcd/core/import/imports.dart';
import '../../../core/network/api_constants.dart';
import '../../../features/home/data/model/button_model.dart';
import '../../../features/home/data/model/dashboard_model.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class HomeScreenController extends GetxController{

  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  List<ButtonModel> actionButtonz = <ButtonModel>[
    ButtonModel(icon: AppAsset.airtime, text: "Airtime", link: Routes.AIRTIME_MODULE),
    ButtonModel(icon: AppAsset.internet, text: "Internet Data", link: Routes.DATA_MODULE),
    ButtonModel(icon: AppAsset.tv, text: "Cable Tv", link: Routes.CABLE_MODULE),
    ButtonModel(icon: AppAsset.electricity, text: "Electricity", link: Routes.ELECTRICITY_MODULE),
    ButtonModel(icon: AppAsset.ball, text: "Betting", link: Routes.BETTING_MODULE),
    ButtonModel(icon: AppAsset.list, text: "Epins", link: "epin"),
    ButtonModel(icon: AppAsset.money, text: "Airtime to cash", link: 'Routes.airtime2cash'),
    ButtonModel(icon: AppAsset.docSearch, text: "Result checker", link: "result_checker"),
    ButtonModel(icon: AppAsset.posIcon, text: "POS", link: 'Routes.pos'),
    ButtonModel(icon: AppAsset.nin, text: "NIN Validation", link: Routes.NIN_VALIDATION_MODULE),
    ButtonModel(icon: AppAsset.gift, text: "Reward Centre", link: "reward"),
    ButtonModel(icon: AppAsset.service, text: "Mega Bulk Service", link: ""),
  ];


  final _dashboardData = Rxn<DashboardModel>();
  set dashboardData(value) => _dashboardData.value = value;
  get dashboardData => _dashboardData.value;

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _errorMessage = ''.obs;
  set errorMessage(value) => _errorMessage.value = value;
  get errorMessage => _errorMessage.value;


  final apiService = ApiService();

  @override
  void onInit() {
    dev.log("HomeScreenController initialized");
    fetchDashboard(); 
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    dev.log("HomeScreenController ready, dashboardData: ${dashboardData != null ? 'loaded' : 'null'}");
  }

  @override
  void onClose() {
  }

  Future<void> fetchDashboard({bool force = false}) async {
    dev.log("fetchDashboard called, force: $force, current data: ${dashboardData != null ? 'exists' : 'null'}");
    
    // Always fetch if data is null
    if (dashboardData != null && !force) {
      dev.log("Dashboard already loaded, skipping fetch");
      return;
    }

    isLoading = true;
    errorMessage = "";
    dev.log("Starting dashboard fetch...");

    final result = await apiService.getrequest("${ApiConstants.authUrlV2}/dashboard");

    result.fold(
      (failure) {
        errorMessage = failure.message;
        dev.log("Dashboard fetch failed: ${failure.message}");
        Get.snackbar("Error", failure.message);
      },
      (data) {
        dev.log("Dashboard fetch success: ${data.toString()}");
        dashboardData = DashboardModel.fromJson(data);
        dev.log("Dashboard model created - User: ${dashboardData?.user.userName}, Balance: ${dashboardData?.balance.wallet}");
        if (force) {
          Get.snackbar("Updated", "Dashboard refreshed");
        }
      },
    );

    isLoading = false;
  }

  Future<void> refreshDashboard() async {
    await fetchDashboard(force: true);
  }

}
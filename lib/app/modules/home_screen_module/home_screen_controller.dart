import 'dart:developer' as dev;

import 'package:get/get.dart';

import '../../../core/constants/app_asset.dart';
import '../../../core/navigators/routes_name.dart';
import '../../../core/network/api_constants.dart';
import '../../../core/network/api_service.dart';
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
    ButtonModel(icon: AppAsset.airtime, text: "Airtime", link: "airtime"),
    ButtonModel(icon: AppAsset.internet, text: "Internet Data", link: "data"),
    ButtonModel(icon: AppAsset.tv, text: "Cable Tv", link: "cableTv"),
    ButtonModel(icon: AppAsset.electricity, text: "Electricity", link: Routes.electricity),
    ButtonModel(icon: AppAsset.ball, text: "Betting", link: "betting"),
    ButtonModel(icon: AppAsset.list, text: "Epins", link: "epin"),
    ButtonModel(icon: AppAsset.money, text: "Airtime to cash", link: Routes.airtime2cash),
    ButtonModel(icon: AppAsset.docSearch, text: "Reseult checker", link: "result_checker"),
    ButtonModel(icon: AppAsset.posIcon, text: "POS", link: Routes.pos),
    ButtonModel(icon: AppAsset.nin, text: "NIN Validation", link: "nin"),
    ButtonModel(icon: AppAsset.gift, text: "Reward Centre", link: "reward"),
    ButtonModel(icon: AppAsset.service, text: "Mega Bulk Service", link: "/airtime"),
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
    fetchDashboard();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
  }

  Future<void> fetchDashboard({bool force = false}) async {
    // prevent multiple calls unless forced
    if (dashboardData != null && !force) {
      dev.log("Dashboard already loaded, skipping fetch");
      return;
    }

    isLoading = true;
    errorMessage = "";

    final result = await apiService.getrequest("${ApiConstants.authUrlV2}/dashboard");

    result.fold(
          (failure) {
        errorMessage = failure.message;
        Get.snackbar("Error", failure.message);
      },
          (data) {
        dashboardData = data;
        dev.log("Dashboard updated: ${data.toString()}");
        if (force) {
          Get.snackbar("Updated", "Dashboard refreshed");
        }
      },
    );

    isLoading = false;
  }

}

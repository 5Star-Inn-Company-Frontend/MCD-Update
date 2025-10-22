import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/features/home/data/model/dashboard_model.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';

class AccountInfoModuleController extends GetxController {
  
  final _dashboardData = Rxn<DashboardModel>();
  set dashboardData(value) => _dashboardData.value = value;
  get dashboardData => _dashboardData.value;

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _errorMessage = ''.obs;
  set errorMessage(value) => _errorMessage.value = value;
  get errorMessage => _errorMessage.value;


  final apiService = DioApiService();

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
        dashboardData = DashboardModel.fromJson(data);
        dev.log("Dashboard updated: ${data.toString()}");
        update();
        if (force) {
          Get.snackbar("Updated", "Dashboard refreshed");
        }
      },
    );

    isLoading = false;
  }

}
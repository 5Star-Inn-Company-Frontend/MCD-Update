import 'package:mcd/core/import/imports.dart';
import 'package:mcd/features/profile/data/model/profile_model.dart';
import 'dart:developer' as dev;

import '../../../core/network/dio_api_service.dart';
import 'package:get_storage/get_storage.dart';

class AccountInfoModuleController extends GetxController {

  final _profileData = Rxn<ProfileModel>();
  set profileData(value) => _profileData.value = value;
  get profileData => _profileData.value;

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _errorMessage = ''.obs;
  set errorMessage(value) => _errorMessage.value = value;
  get errorMessage => _errorMessage.value;

  final apiService = DioApiService();
  final box = GetStorage();

  @override
  void onInit() {
    dev.log("AccountInfoModuleController: onInit called");
    fetchProfile(); 
    super.onInit();
  }

  @override
  void onReady() {
    dev.log("AccountInfoModuleController: onReady - profileData: ${profileData != null}");
    super.onReady();
  }

  @override
  void onClose() {
    dev.log("AccountInfoModuleController: onClose called");
  }

  Future<void> fetchProfile({bool force = false}) async {
    dev.log("AccountInfoModuleController: fetchProfile called - force: $force, existing data: ${profileData != null}");
    
    if (profileData != null && !force) {
      dev.log("AccountInfoModuleController: Profile already loaded, skipping fetch");
      return;
    }

    final utilityUrl = box.read('utility_service_url');
    dev.log("AccountInfoModuleController: Retrieved utility URL from storage: $utilityUrl");
    
    if (utilityUrl == null || utilityUrl.isEmpty) {
      errorMessage = "Utility service URL not found";
      dev.log("AccountInfoModuleController: ERROR - Utility URL is missing from storage");
      Get.snackbar("Error", "Service configuration error");
      return;
    }

    isLoading = true;
    errorMessage = "";
    dev.log("AccountInfoModuleController: Starting profile fetch from: ${utilityUrl}profile");

    final result = await apiService.getJsonRequest("${utilityUrl}profile");

    result.fold(
      (failure) {
        errorMessage = failure.message;
        dev.log("AccountInfoModuleController: Profile fetch failed - ${failure.message}");
        Get.snackbar("Error", failure.message);
      },
      (data) {
        dev.log("AccountInfoModuleController: Profile fetch success - Raw data: ${data.toString()}");
        profileData = ProfileModel.fromJson(data);
        dev.log("AccountInfoModuleController: Profile model created - Name: ${profileData?.fullName}, Email: ${profileData?.email}");
        if (force) {
          Get.snackbar("Updated", "Profile refreshed");
        }
      },
    );

    isLoading = false;
    dev.log("AccountInfoModuleController: fetchProfile completed - isLoading: $isLoading");
  }

  Future<void> refreshProfile() async {
    dev.log("AccountInfoModuleController: refreshProfile called - triggering force fetch");
    await fetchProfile(force: true);
  }
}
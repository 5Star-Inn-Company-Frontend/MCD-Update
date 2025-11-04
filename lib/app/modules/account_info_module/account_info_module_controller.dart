import 'package:mcd/core/import/imports.dart';
import 'package:mcd/app/modules/account_info_module/model/profile_model.dart';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

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

  final _isUploading = false.obs;
  set isUploading(value) => _isUploading.value = value;
  get isUploading => _isUploading.value;

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
      Get.snackbar("Error", "Service configuration error",
          backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
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
        Get.snackbar("Error", failure.message,
            backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dev.log("AccountInfoModuleController: Profile fetch success - Raw data: ${data.toString()}");
        profileData = ProfileModel.fromJson(data);
        dev.log("AccountInfoModuleController: Profile model created - Name: ${profileData?.fullName}, Email: ${profileData?.email}");
        if (force) {
          Get.snackbar("Updated", "Profile refreshed",
              backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
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

  Future<void> uploadProfilePicture() async {
    try {
      dev.log("AccountInfoModuleController: Starting profile picture upload");
      
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) {
        dev.log("AccountInfoModuleController: No image selected");
        return;
      }

      dev.log("AccountInfoModuleController: Image selected: ${image.path}");

      final utilityUrl = box.read('utility_service_url');
      dev.log("AccountInfoModuleController: Retrieved utility URL: $utilityUrl");
      
      if (utilityUrl == null || utilityUrl.isEmpty) {
        dev.log("AccountInfoModuleController: ERROR - Utility URL missing");
        Get.snackbar("Error", "Service configuration error",
            backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      isUploading = true;
      dev.log("AccountInfoModuleController: Converting image to base64");

      // Read image as bytes
      final bytes = await File(image.path).readAsBytes();
      final base64Image = base64Encode(bytes);
      
      dev.log("AccountInfoModuleController: Base64 length: ${base64Image.length}");
      dev.log("AccountInfoModuleController: Uploading to: ${utilityUrl}uploaddp");

      final result = await apiService.postJsonRequest(
        "${utilityUrl}uploaddp",
        {"dp": base64Image}
      );

      result.fold(
        (failure) {
          dev.log("AccountInfoModuleController: Upload failed - ${failure.message}");
          Get.snackbar("Error", failure.message,
              backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        },
        (data) {
          dev.log("AccountInfoModuleController: Upload success - ${data.toString()}");
      Get.snackbar("Success", "Profile picture updated successfully",
        backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
          // Refresh profile to show new picture
          fetchProfile(force: true);
        },
      );

    } catch (e) {
      dev.log("AccountInfoModuleController: Upload exception - $e");
      Get.snackbar("Error", "Failed to upload image: $e",
          backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
    } finally {
      isUploading = false;
      dev.log("AccountInfoModuleController: Upload completed - isUploading: $isUploading");
    }


}  }
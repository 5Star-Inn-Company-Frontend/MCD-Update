import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mcd/app/widgets/loading_dialog.dart';
import 'package:mcd/core/network/api_service.dart';
import 'package:mcd/features/auth/domain/entities/user_signup_data.dart';

import '../../../core/utils/validator.dart';
import '../../../features/home/data/model/dashboard_model.dart';
import '../../routes/app_pages.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class LoginScreenController extends GetxController {
  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final formKey = GlobalKey<FormState>();

  final isEmail = true.obs;
  // set isEmail(value) => _isEmail.value = value;
  // get isEmail => _isEmail.value;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final PhoneNumber number = PhoneNumber(isoCode: 'NG');

  var isPasswordVisible = true.obs;
  // set isPasswordVisible(value) => _isPasswordVisible.value = value;
  // get isPasswordVisible => _isPasswordVisible.value;

  var isFormValid = false.obs;
  // set isFormValid(value) => _isFormValid.value = value;
  // get isFormValid => _isFormValid.value;

  final _errorText = "".obs;
  set errorText(value) => _errorText.value = value;
  get errorText => _errorText.value;

  void validateInput(String value) {
    if (CustomValidator.isValidAccountNumber(value.trim()) == false) {
      errorText = 'Please enter a valid phone';
    } else {
      errorText = "";
    }
  }

  void setFormValidState() {
    if (formKey.currentState == null) return;
    if (formKey.currentState!.validate()) {
      if (isEmail.value == false) {
        if (phoneNumberController.text.isNotEmpty) {
          isFormValid.value = true;
        } else {
          isFormValid.value = false;
          validateInput(phoneNumberController.text.trim());
        }
      } else {
        isFormValid.value = true;
      }
    } else {
      isFormValid.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    countryController.text = "+234";
  }

  ApiService apiService = ApiService();

  final box = GetStorage();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  UserSignupData? pendingSignupData;
  final RxBool isOtpSent = false.obs;
  final dashboardData = Rxn<DashboardModel>();

  Future<void> login(
      BuildContext context, String username, String password) async {
    try {
      showLoadingDialog(context: context);
      isLoading.value = true;
      errorMessage.value = null;

      final result = await apiService
          .postrequest("https://auth.mcd.5starcompany.com.ng/api/v2/login", {"user_name": username, "password": password});

      Get.back();

      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          Get.snackbar("Error", errorMessage.value!);
        },
        (data) async {
          final success = data['success'];
          if (success == 1 && data['token'] != null) {
            // normal login
            final token = data['token'];
            await box.write('token', token);
            // Get.offAllNamed(AppRoutes.homenav);
            await handleLoginSuccess();
          } else if (success == 2 && data['pin'] == true) {
            // 2FA required
            Get.toNamed(Routes.PIN_VERIFY, arguments: {"username": username});
          } else if (/* detect new device case */ data['message']
                  ?.contains("device") ==
              true) {
            // new Device
            Get.toNamed(Routes.NEW_DEVICE_VERIFY,
                arguments: {"username": username});
          } else {
            Get.snackbar("Error", data['message'] ?? "Login failed");
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = "Unexpected error: $e";
      Get.snackbar("Error", errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDashboard({bool force = false}) async {
    // prevent multiple calls unless forced
    if (dashboardData.value != null && !force) {
      dev.log("Dashboard already loaded, skipping fetch");
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    final result = await apiService.getrequest("/dashboard");

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        Get.snackbar("Error", failure.message);
      },
      (data) {
        dashboardData.value = data;
        dev.log("Dashboard updated: ${data.toString()}");
        if (force) {
          Get.snackbar("Updated", "Dashboard refreshed");
        }
      },
    );

    isLoading.value = false;
  }

  /// After login success, preload dashboard
  Future<void> handleLoginSuccess() async {
    await fetchDashboard(force: true);
    Get.offAllNamed(Routes.HOME_NAVIGATION);
  }

  Future<void> logout() async {
    try {
      await box.remove('token'); // remove only token
    } catch (e) {
      dev.log("Logout error: $e");
    }
  }

}

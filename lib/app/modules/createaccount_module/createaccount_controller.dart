import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/features/auth/domain/entities/user_signup_data.dart';

import '../../../core/network/api_service.dart';
import '../../../features/home/data/model/dashboard_model.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class createaccountController extends GetxController {
  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final formKey = GlobalKey<FormState>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final _isPasswordVisible = false.obs;
  set isPasswordVisible(value) => _isPasswordVisible.value = value;
  get isPasswordVisible => _isPasswordVisible.value;

  final _isFormValid = false.obs;
  set isFormValid(value) => _isFormValid.value = value;
  get isFormValid => _isFormValid.value;

  final box = GetStorage();

  final isLoading = false.obs;
  final errorMessage = RxnString();
  UserSignupData? pendingSignupData;
  final RxBool isOtpSent = false.obs;

  final dashboardData = Rxn<DashboardModel>();

  void validateForm() {
    if (formKey.currentState == null) return;
    isFormValid = formKey.currentState!.validate();
  }

  @override
  void onInit() {
    countryController.text = "+234";
    super.onInit();
  }

  ApiService apiService = ApiService();

  Future<void> createaccount(otp) async {
    var jsondata = {
      "user_name": usernameController.text.trim(),
      "password": passwordController.text.trim(),
      "phoneno": phoneNumberController.text.trim(),
      "email": emailController.text.trim(),
      "referral": "",
      "code": otp,
      "version": "1.0.0",
    };
    try {
      var result = await apiService.postrequest("/signup", jsondata);
      result.fold(
        (failure) {
          errorMessage.value = failure.message;
          dev.log("Signup error: ${errorMessage.value}");
          Get.snackbar("Error", errorMessage.value!);
        },
        (authResult) {
          if (authResult.success) {
            dev.log("Signup successful");
            Get.snackbar("Success", "Registration complete, please login");
            Get.offAllNamed(Routes.LOGIN_SCREEN);
          } else {
            dev.log("Signup failed: ${authResult.message}");
            Get.snackbar("Error", authResult.message ?? "Signup failed");
          }
        },
      );
    } catch (e) {
      Get.snackbar("Error", "Unexpected error: $e");
    }
  }
}

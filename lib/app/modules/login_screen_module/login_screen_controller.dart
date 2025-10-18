import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mcd/app/widgets/loading_dialog.dart';
import 'package:mcd/core/network/api_service.dart';
import 'package:mcd/features/auth/domain/entities/user_signup_data.dart';

import '../../../core/network/api_constants.dart';
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

  final _isEmail = true.obs;
  set isEmail(value) => _isEmail.value = value;
  get isEmail => _isEmail.value;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final PhoneNumber number = PhoneNumber(isoCode: 'NG');

  var _isPasswordVisible = true.obs;
  set isPasswordVisible(value) => _isPasswordVisible.value = value;
  get isPasswordVisible => _isPasswordVisible; // Remove .value here

  var _isFormValid = false.obs;
  set isFormValid(value) => _isFormValid.value = value;
  get isFormValid => _isFormValid.value;

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
      if (isEmail == false) {
        if (phoneNumberController.text.isNotEmpty) {
          isFormValid = true;
        } else {
          isFormValid = false;
          validateInput(phoneNumberController.text.trim());
        }
      } else {
        isFormValid = true;
      }
    } else {
      isFormValid = false;
    }
  }

  final LocalAuthentication auth = LocalAuthentication();
  
  final _canCheckBiometrics = false.obs;
  set canCheckBiometrics(value) => _canCheckBiometrics.value = value;
  get canCheckBiometrics => _canCheckBiometrics.value;

  @override
  void onInit() {
    super.onInit();
    countryController.text = "+234";
    checkBiometricSupport();
  }

  ApiService apiService = ApiService();

  final box = GetStorage();

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;

  final _errorMessage = RxnString();
  set errorMessage(value) => _errorMessage.value = value;
  get errorMessage => _errorMessage.value;

  UserSignupData? pendingSignupData;
  final RxBool _isOtpSent = false.obs;
  set isOtpSent(value) => _isOtpSent.value = value;
  get isOtpSent => _isOtpSent.value;


  final _dashboardData = Rxn<DashboardModel>();
  set dashboardData(value) => _dashboardData.value = value;
  get dashboardData => _dashboardData.value;



  Future<void> login(
      BuildContext context, String username, String password) async {
    try {
      showLoadingDialog(context: context);
      isLoading = true;
      errorMessage = null;
      dev.log("Login attempt for user: $username");

      final result = await apiService
          .postrequest("${ApiConstants.authUrlV2}/login", {"user_name": username, "password": password});

      Get.back();

      result.fold(
        (failure) {
          errorMessage = failure.message;
          dev.log("Login failed: ${failure.message}");
          Get.snackbar("Error", errorMessage!);
        },
        (data) async {
          dev.log("Login response received: ${data.toString()}");
          final success = data['success'];
          if (success == 1 && data['token'] != null) {
            final token = data['token'];
            final transactionUrl = data['transaction_service'];
            final utilityUrl = data['ultility_service'];

            await box.write('token', token);
            await box.write('transaction_service_url', transactionUrl);
            await box.write('utility_service_url', utilityUrl);
            
            // Save credentials for biometric login
            await saveBiometricCredentials(username);
            
            dev.log("Token saved, navigating to home...");
            
            await handleLoginSuccess();
          } else if (success == 2 && data['pin'] == true) {
            dev.log("PIN verification required");
            Get.toNamed(Routes.PIN_VERIFY, arguments: {"username": username});
          } else if (data['message']?.contains("device") == true) {
            dev.log("New device verification required");
            Get.toNamed(Routes.NEW_DEVICE_VERIFY,
                arguments: {"username": username});
          } else {
            dev.log('Login error: ${data['message']}');
            Get.snackbar("Error", data['message'] ?? "Login failed");
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage = "Unexpected error: $e";
      dev.log('Login exception: $errorMessage');
      Get.snackbar("Error", errorMessage!);
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchDashboard({bool force = false}) async {
    dev.log("LoginController fetchDashboard called, force: $force");
    
    if (dashboardData != null && !force) {
      dev.log("Dashboard already loaded in LoginController");
      return;
    }

    isLoading = true;
    errorMessage = null;
    dev.log("Fetching dashboard from LoginController...");

    final result = await apiService.getrequest("${ApiConstants.authUrlV2}/dashboard");

    result.fold(
      (failure) {
        errorMessage = failure.message;
        dev.log("LoginController dashboard fetch failed: ${failure.message}");
        Get.snackbar("Error", failure.message);
      },
      (data) {
        dashboardData = DashboardModel.fromJson(data);
        dev.log("LoginController dashboard loaded: ${dashboardData?.user.userName}");
        if (force) {
          Get.snackbar("Updated", "Dashboard refreshed");
        }
      },
    );

    isLoading = false;
  }

  /// Check if device supports biometrics
  Future<void> checkBiometricSupport() async {
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      dev.log("Biometric support available: $canCheckBiometrics");
    } catch (e) {
      dev.log("Error checking biometric support: $e");
      canCheckBiometrics = false;
    }
  }

  /// Biometric login
  Future<void> biometricLogin(BuildContext context) async {
    try {
      if (!canCheckBiometrics) {
        Get.snackbar("Error", "Biometric authentication not available");
        return;
      }

      // Check if user has saved credentials for biometric
      final savedUsername = box.read('biometric_username');
      if (savedUsername == null) {
        Get.snackbar("Error", "No saved biometric credentials. Please login normally first.");
        return;
      }

      dev.log("Starting biometric authentication...");
      
      final bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to login',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (!authenticated) {
        dev.log("Biometric authentication failed");
        Get.snackbar("Error", "Authentication failed");
        return;
      }

      dev.log("Biometric authentication successful, calling API...");
      
      showLoadingDialog(context: context);
      isLoading = true;
      errorMessage = null;

      final result = await apiService.getrequest(
        "${ApiConstants.authUrlV2}/biometriclogin"
      );

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage = failure.message;
          dev.log("Biometric login failed: ${failure.message}");
          Get.snackbar("Error", errorMessage!);
        },
        (data) async {
          dev.log("Biometric login response: ${data.toString()}");
          final success = data['success'];
          
          if (success == 1 && data['token'] != null) {
            final token = data['token'];
            final transactionUrl = data['transaction_service'];
            final utilityUrl = data['ultility_service'];

            await box.write('token', token);
            await box.write('transaction_service_url', transactionUrl);
            await box.write('utility_service_url', utilityUrl);
            dev.log("Biometric login successful, navigating to home...");
            
            await handleLoginSuccess();
          } else {
            errorMessage = data['message'] ?? "Biometric login failed";
            dev.log("Biometric login error: ${errorMessage}");
            Get.snackbar("Error", errorMessage!);
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage = "Biometric login error: $e";
      dev.log("Biometric login exception: $errorMessage");
      Get.snackbar("Error", "Authentication failed. Please try again.");
    } finally {
      isLoading = false;
    }
  }

  /// Save username for biometric login after successful login
  Future<void> saveBiometricCredentials(String username) async {
    try {
      await box.write('biometric_username', username);
      dev.log("Biometric credentials saved for: $username");
    } catch (e) {
      dev.log("Error saving biometric credentials: $e");
    }
  }

  /// Navigate to home after successful login
  Future<void> handleLoginSuccess() async {
    dev.log("handleLoginSuccess called");
    await fetchDashboard(force: true);
    dev.log("Navigating to HOME_SCREEN");
    Get.offAllNamed(Routes.HOME_SCREEN);
  }

  Future<void> logout() async {
    try {
      await box.remove('token');
      // Optionally clear biometric data on logout
      // await box.remove('biometric_username');
    } catch (e) {
      dev.log("Logout error: $e");
    }
  }

}

import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mcd/app/modules/home_screen_module/model/dashboard_model.dart';
import 'package:mcd/app/modules/login_screen_module/models/user_signup_data.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/widgets/loading_dialog.dart';

import '../../../core/network/api_constants.dart';
import '../../../core/network/dio_api_service.dart';
import '../../../core/utils/validator.dart';
import '../../routes/app_pages.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class LoginScreenController extends GetxController {
  final _obj = ''.obs;
  set obj(value) => _obj.value = value;
  String get obj => _obj.value;

  final formKey = GlobalKey<FormState>();

  final _isEmail = true.obs;
  set isEmail(value) => _isEmail.value = value;
  bool get isEmail => _isEmail.value;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final PhoneNumber number = PhoneNumber(isoCode: 'NG');

  var _isPasswordVisible = true.obs;
  set isPasswordVisible(value) => _isPasswordVisible.value = value;
  RxBool get isPasswordVisible => _isPasswordVisible; // Remove .value here

  var _isFormValid = false.obs;
  set isFormValid(value) => _isFormValid.value = value;
  bool get isFormValid => _isFormValid.value;

  final _errorText = "".obs;
  set errorText(value) => _errorText.value = value;
  String get errorText => _errorText.value;

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
  bool get canCheckBiometrics => _canCheckBiometrics.value;

  final _isBiometricSetup = false.obs;
  set isBiometricSetup(value) => _isBiometricSetup.value = value;
  bool get isBiometricSetup => _isBiometricSetup.value;

  @override
  void onInit() {
    super.onInit();
    countryController.text = "+234";
    checkBiometricSupport();
    checkBiometricSetup();
  }

  @override
  void onReady() {
    super.onReady();
    // Re-check biometric setup status when screen is ready
    checkBiometricSetup();
  }

  /// check if biometric is fully setup (enabled and has saved credentials)
  void checkBiometricSetup() {
    final isBiometricEnabled = box.read('biometric_enabled');
    final savedUsername = box.read('biometric_username');
    isBiometricSetup = (isBiometricEnabled == true && savedUsername != null && savedUsername.toString().isNotEmpty);
    dev.log("Biometric setup status: $isBiometricSetup (enabled: $isBiometricEnabled, username saved: ${savedUsername != null}");
  }

  var apiService = DioApiService();

  final box = GetStorage();
  final secureStorage = const FlutterSecureStorage();

  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  bool get isLoading => _isLoading.value;

  final _errorMessage = RxnString();
  set errorMessage(value) => _errorMessage.value = value;
  String? get errorMessage => _errorMessage.value;

  UserSignupData? pendingSignupData;
  final RxBool _isOtpSent = false.obs;
  set isOtpSent(value) => _isOtpSent.value = value;
  bool get isOtpSent => _isOtpSent.value;


  final _dashboardData = Rxn<DashboardModel>();
  set dashboardData(value) => _dashboardData.value = value;
  DashboardModel? get dashboardData => _dashboardData.value;



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
          Get.snackbar("Error", errorMessage!, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
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
            
            // save credentials for biometric login
            await saveBiometricCredentials(username, password);
            
            // refresh biometric setup status
            checkBiometricSetup();
            
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
            Get.snackbar("Error", data['message'] ?? "Login failed", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage = "Unexpected error: $e";
      dev.log('Login exception: $errorMessage');
      Get.snackbar("Error", errorMessage!, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
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
        Get.snackbar("Error", failure.message, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
      },
      (data) {
        dashboardData = DashboardModel.fromJson(data);
        dev.log("LoginController dashboard loaded: ${dashboardData?.user.userName}");
        if (force) {
          // Get.snackbar("Updated", "Dashboard refreshed", backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
        }
      },
    );

    isLoading = false;
  }

  /// check if device supports biometrics
  Future<void> checkBiometricSupport() async {
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      dev.log("Biometric support available: $canCheckBiometrics");
    } catch (e) {
      dev.log("Error checking biometric support: $e");
      canCheckBiometrics = false;
    }
  }

  /// biometric login
  Future<void> biometricLogin(BuildContext context) async {
    try {
      if (!canCheckBiometrics) {
        Get.snackbar("Error", "Biometric authentication not available", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      // check if user has saved credentials for biometric
      final isBiometricEnabled = box.read('biometric_enabled');
      final savedUsername = box.read('biometric_username');
      
      if (isBiometricEnabled != true) {
        Get.snackbar("Error", "Biometric login is disabled. Please enable it in Settings.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }
      
      if (savedUsername == null || savedUsername.toString().isEmpty) {
        Get.snackbar("Error", "No saved biometric credentials. Please login normally first.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
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
        Get.snackbar("Error", "Authentication failed", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      dev.log("Biometric authentication successful, logging in with saved credentials...");
      
      // Get saved password from secure storage
      final savedPassword = await secureStorage.read(key: 'biometric_password');
      
      if (savedPassword == null || savedPassword.isEmpty) {
        Get.snackbar(
          "Error", 
          "No saved password. Please login normally first.",
          backgroundColor: AppColors.errorBgColor, 
          colorText: AppColors.textSnackbarColor
        );
        return;
      }

      // Use normal login method with saved credentials
      dev.log("Calling normal login with saved credentials...");
      await login(context, savedUsername.toString(), savedPassword);

      /* API-based biometric login (commented out)
      final result = await apiService.getrequest(
        "${ApiConstants.authUrlV2}/biometriclogin"
      );

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage = failure.message;
          dev.log("Biometric login failed: ${failure.message}");
          
          // If it's an unauthorized error, clear biometric data and ask user to login normally
          if (failure.message.contains("Unauthorized")) {
            box.remove('biometric_username');
            Get.snackbar(
              "Biometric Login Expired", 
              "Please log in again with your credentials to re-enable biometric login",
              backgroundColor: AppColors.errorBgColor, 
              colorText: AppColors.textSnackbarColor,
              duration: const Duration(seconds: 4),
            );
          } else {
            Get.snackbar("Error", errorMessage!, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
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
            dev.log("Biometric login error: $errorMessage");
            Get.snackbar("Error", errorMessage!, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
        },
      );
      */
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      errorMessage = "Biometric login error: $e";
      dev.log("Biometric login exception: $errorMessage");
      Get.snackbar("Error", "Authentication failed. Please try again.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
    } finally {
      isLoading = false;
    }
  }

  /// save username and password for biometric login after successful login
  Future<void> saveBiometricCredentials(String username, String password) async {
    try {
      // only save credentials if biometric is enabled in settings
      final isBiometricEnabled = box.read('biometric_enabled');
      if (isBiometricEnabled == true) {
        await box.write('biometric_username', username);
        await secureStorage.write(key: 'biometric_password', value: password);
        dev.log("Biometric credentials saved for: $username");
      }
    } catch (e) {
      dev.log("Error saving biometric credentials: $e");
    }
  }

  /// navigate to home after successful login
  Future<void> handleLoginSuccess() async {
    await fetchDashboard(force: true);
    Get.offAllNamed(Routes.HOME_SCREEN);
  }

  /// social login (facebook/google)
  Future<void> socialLogin(
    BuildContext context,
    String email,
    String name,
    String avatar,
    String accessToken,
    String source,
  ) async {
    try {
      showLoadingDialog(context: context);
      isLoading = true;
      errorMessage = null;
      dev.log("Social login attempt for: $email from $source");

      final body = {
        "email": email,
        "name": name,
        "avatar": avatar,
        "access_token": accessToken,
        "source": source,
      };

      final result = await apiService.postrequest(
        "${ApiConstants.authUrlV2}/sociallogin",
        body,
      );

      Get.back(); // close loader

      result.fold(
        (failure) {
          errorMessage = failure.message;
          dev.log("Social login failed: ${failure.message}");
          Get.snackbar("Error", errorMessage!, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        },
        (data) async {
          dev.log("Social login response: ${data.toString()}");
          final success = data['success'];
          
          if (success == 1 && data['token'] != null) {
            final token = data['token'];
            final transactionUrl = data['transaction_service'];
            final utilityUrl = data['ultility_service'];

            await box.write('token', token);
            await box.write('transaction_service_url', transactionUrl);
            await box.write('utility_service_url', utilityUrl);
            
            dev.log("Social login successful, navigating to home...");
            await handleLoginSuccess();
          } else {
            errorMessage = data['message'] ?? "Social login failed";
            dev.log("Social login error: $errorMessage");
            Get.snackbar("Error", errorMessage!, backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage = "Social login error: $e";
      dev.log("Social login exception: $errorMessage");
      Get.snackbar("Error", "Authentication failed. Please try again.", backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
    } finally {
      isLoading = false;
    }
  }

  Future<void> logout() async {
    try {
      await box.remove('token');
      // Optionally clear biometric data on logout
      // await box.remove('biometric_enabled');
    } catch (e) {
      dev.log("Logout error: $e");
    }
  }

}

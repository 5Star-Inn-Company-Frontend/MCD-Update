import 'dart:developer' as dev;
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/import/imports.dart';
import '../../../core/network/dio_api_service.dart';

class NumberVerificationModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  
  final isLoading = false.obs;
  
  String? _redirectTo;
  bool _isMultipleAirtimeAdd = false;

  @override
  void onInit() {
    super.onInit();
    // Get the redirect route from navigation arguments
    _redirectTo = Get.arguments?['redirectTo'];
    _isMultipleAirtimeAdd = Get.arguments?['isMultipleAirtimeAdd'] ?? false;
    
    // Pre-fill phone number if provided (for multiple airtime)
    final preFilledNumber = Get.arguments?['phoneNumber'];
    if (preFilledNumber != null) {
      phoneController.text = preFilledNumber;
    }
    
    dev.log('NumberVerificationModule initialized with redirectTo: $_redirectTo, isMultipleAirtimeAdd: $_isMultipleAirtimeAdd', name: 'NumberVerification');
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> verifyNumber() async {
    if (formKey.currentState?.validate() ?? false) {
      await _callValidationApi();
    }
  }

  Future<void> _callValidationApi() async {
    isLoading.value = true;
    try {
      final transactionUrl = box.read('transaction_service_url');
      if (transactionUrl == null) {
        Get.snackbar("Error", "Transaction URL not found. Please log in again.",
            backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        return;
      }

      final serviceName = (_redirectTo?.contains('data') ?? false) ? 'data' : 'airtime';

      final body = {
        "service": serviceName,
        "provider": "Ng",
        "number": phoneController.text,
      };

      dev.log('Validation request body: $body', name: 'NumberVerification');
      final result = await apiService.postrequest('$transactionUrl''validate-number', body);
      dev.log('Validation request sent to: $transactionUrl''validate-number', name: 'NumberVerification');

      result.fold(
        (failure) {
          dev.log('Verification Failed: ${failure.message}', name: 'NumberVerification');
          Get.snackbar("Verification Failed", failure.message,
              backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
        },
        (data) {
          dev.log('Verification response: $data', name: 'NumberVerification');
          if (data['success'] == 1) {
            final networkName = data['data']?['operatorName'] ?? 'Unknown Network';
            final networkData = data['data'] ?? {};
            dev.log('Network verified: "$networkName" (Full data: $networkData)', name: 'NumberVerification');
            _showConfirmationDialog(phoneController.text, networkName, networkData);
            } else {
            dev.log("Verification Failed: ${data['message']}", name: 'NumberVerification');
            Get.snackbar("Verification Failed", data['message'] ?? "Could not verify number.",
                backgroundColor: AppColors.errorBgColor, colorText: AppColors.textSnackbarColor);
          }
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showConfirmationDialog(String phoneNumber, String networkName, Map<String, dynamic> networkData) {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      title: '',
      content: Padding(
        padding: const EdgeInsets.only(top: 0, left: 24.0, right: 24.0, bottom: 16.0),
        child: Column(
          children: [
            // Gap(20),
            Image.asset('assets/images/mcdagentlogo.png', height: 80),
        
            Gap(20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Mega Cheap Data detected ",
                style: const TextStyle(
                  color: AppColors.background,
                  fontFamily: AppFonts.manRope,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: phoneNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: AppFonts.manRope
                    ),
                  ),
                  const TextSpan(
                    text: " is an ",
                    style: TextStyle(
                      fontFamily: AppFonts.manRope
                    ),
                  ),
                  TextSpan(
                    text: networkName,
                    style:  TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: AppFonts.manRope
                    ),
                  ),
                  const TextSpan(
                    text: " number?",
                    style: TextStyle(
                      fontFamily: AppFonts.manRope
                    ),
                  ),
                ],
              ),
            ),
        
            Gap(20),
            button('Cancel', AppColors.primaryColor.withOpacity(0.1), AppColors.primaryColor)
                .onTap(() {
                  dev.log('User cancelled confirmation', name: 'NumberVerification');
                  Get.back(); // Close dialog
                }),
        
            Gap(20),
            button('Confirm', AppColors.primaryColor, Colors.white)
                .onTap(() {
                  Get.back(); // Close dialog
                  dev.log('Number confirmed. Navigating to: $_redirectTo with network: $networkName', name: 'NumberVerification');
                  
                  // Use a post frame callback to ensure dialog is fully closed
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_isMultipleAirtimeAdd) {
                      // For multiple airtime, return the verified data instead of navigating
                      dev.log('Returning verified data for multiple airtime add', name: 'NumberVerification');
                      Get.back(result: {
                        'verifiedNumber': phoneNumber,
                        'verifiedNetwork': networkName,
                        'networkData': networkData,
                      });
                    } else if (_redirectTo != null) {
                      // Navigate without disposing this controller immediately
                      // Pass both verified number and network information
                      Get.offNamed(_redirectTo!, arguments: {
                        'verifiedNumber': phoneNumber,
                        'verifiedNetwork': networkName,
                        'networkData': networkData,
                      });
                    } else {
                      Get.snackbar("Success", "Number verified!",
                          backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
                      Get.back();
                    }
                  });
                }),
          ],
        ),
      )
      // title: "Confirm Network",
      // titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppFonts.manRope,),
      // middleText: "Is the number $phoneNumber a $networkName number?",
      // middleTextStyle: const TextStyle(fontFamily: AppFonts.manRope,),
      // textConfirm: "Confirm",
      // textCancel: "Cancel",
      // confirmTextColor: Colors.white,
      // barrierDismissible: false,
      // contentPadding: EdgeInsets.all(20),
      // radius: 12,
      // onConfirm: () {
      //   Get.back(); // Close dialog
      //   dev.log('Number confirmed. Navigating to: $_redirectTo with network: $networkName', name: 'NumberVerification');
        
      //   // Use a post frame callback to ensure dialog is fully closed
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     if (_redirectTo != null) {
      //       // Navigate without disposing this controller immediately
      //       // Pass both verified number and network information
      //       Get.offNamed(_redirectTo!, arguments: {
      //         'verifiedNumber': phoneNumber,
      //         'verifiedNetwork': networkName,
      //         'networkData': networkData,
      //       });
      //     } else {
      //       Get.snackbar("Success", "Number verified!",
      //           backgroundColor: AppColors.successBgColor, colorText: AppColors.textSnackbarColor);
      //       Get.back();
      //     }
      //   });
      // },
      // onCancel: () {
      //   dev.log('User cancelled confirmation', name: 'NumberVerification');
      // },
    );
  }

  Widget button(String text, Color color, Color textColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Center(child: TextSemiBold(text, color: textColor,)),
    );
  }
}

extension on Widget {
  Widget onTap(void Function()? param0) {
    return GestureDetector(
      onTap: param0,
      child: this,
    );
  }
}

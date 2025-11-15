import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosTermOtpModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTermOtpModuleController initialized', name: 'PosTermOtp');
  }

  @override
  void onClose() {
    dev.log('PosTermOtpModuleController disposed', name: 'PosTermOtp');
    super.onClose();
  }
}

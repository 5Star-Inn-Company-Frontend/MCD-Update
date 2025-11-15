import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosTermAgreementModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTermAgreementModuleController initialized', name: 'PosTermAgreement');
  }

  @override
  void onClose() {
    dev.log('PosTermAgreementModuleController disposed', name: 'PosTermAgreement');
    super.onClose();
  }
}

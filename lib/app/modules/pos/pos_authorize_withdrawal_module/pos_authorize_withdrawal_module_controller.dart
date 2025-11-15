import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosAuthorizeWithdrawalModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  final pin = <String>[].obs;
  final int pinLength = 4;

  void onPinPressed(String value) {
    if (value == '⌫') {
      if (pin.isNotEmpty) pin.removeLast();
    } else if (pin.length < pinLength && value.isNotEmpty) {
      pin.add(value);
    }
  }

  @override
  void onInit() {
    super.onInit();
    dev.log('PosAuthorizeWithdrawalModuleController initialized', name: 'PosAuthorizeWithdrawal');
  }

  @override
  void onClose() {
    dev.log('PosAuthorizeWithdrawalModuleController disposed', name: 'PosAuthorizeWithdrawal');
    super.onClose();
  }
}

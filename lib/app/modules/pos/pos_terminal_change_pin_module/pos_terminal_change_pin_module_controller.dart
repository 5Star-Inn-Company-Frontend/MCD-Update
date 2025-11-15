import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosTerminalChangePinModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  final currentPinController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTerminalChangePinModuleController initialized', name: 'PosTerminalChangePin');
  }

  @override
  void onClose() {
    currentPinController.dispose();
    newPinController.dispose();
    confirmPinController.dispose();
    dev.log('PosTerminalChangePinModuleController disposed', name: 'PosTerminalChangePin');
    super.onClose();
  }
}

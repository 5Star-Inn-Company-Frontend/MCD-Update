import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosMapTermModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  final serialNumberController = TextEditingController();
  final selectedTerminalType = ''.obs;

  void mapTerminal() {
    // Implement terminal mapping logic
    Get.snackbar('Success', 'Terminal mapped successfully');
  }

  @override
  void onInit() {
    super.onInit();
    dev.log('PosMapTermModuleController initialized', name: 'PosMapTerm');
  }

  @override
  void onClose() {
    serialNumberController.dispose();
    dev.log('PosMapTermModuleController disposed', name: 'PosMapTerm');
    super.onClose();
  }
}

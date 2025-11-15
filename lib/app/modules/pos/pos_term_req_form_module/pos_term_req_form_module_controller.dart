import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosTermReqFormModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  
  final addressDeliveryController = TextEditingController();
  final contactNameController = TextEditingController();
  final contactEmailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  
  final terminalType = ''.obs;
  final purchaseType = ''.obs;
  final accountType = ''.obs;
  final numOfPos = ''.obs;
  final selectState = ''.obs;
  final selectCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTermReqFormModuleController initialized', name: 'PosTermReqForm');
  }

  @override
  void onClose() {
    addressDeliveryController.dispose();
    contactNameController.dispose();
    contactEmailController.dispose();
    phoneNumberController.dispose();
    dev.log('PosTermReqFormModuleController disposed', name: 'PosTermReqForm');
    super.onClose();
  }
}

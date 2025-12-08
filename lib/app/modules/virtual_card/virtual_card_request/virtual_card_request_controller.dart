import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualCardRequestController extends GetxController {
  final amountController = TextEditingController();

  final selectedCurrency1 = ''.obs;
  final selectedCardType = ''.obs;

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}

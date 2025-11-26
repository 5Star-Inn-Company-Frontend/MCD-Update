import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VirtualCardRequestController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  final _selectedDob = Rxn<String>();
  String? get selectedDob => _selectedDob.value;
  set selectedDob(String? value) => _selectedDob.value = value;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }
}

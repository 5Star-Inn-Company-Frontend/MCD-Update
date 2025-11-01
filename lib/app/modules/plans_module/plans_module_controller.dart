import 'package:get/get.dart';

class PlansModuleController extends GetxController {
  final List<String> planFeatures = [
    "Bronze is for or small and medium businesses ",
    "Bronze is for or small and medium businesses ",
    "Bronze is for or small and medium businesses ",
    "Bronze is for or small and medium businesses ",
    "Bronze is for or small and medium businesses ",
    "Bronze is for or small and medium businesses ",
    "Bronze is for or small and medium businesses ",
    "Bronze is for or small and medium businesses ",
  ];

  final args = Get.arguments as Map<String, dynamic>?;

  dynamic get _isAppbar => args?['isAppbar'] ?? true.obs;
  bool get isAppbar => _isAppbar.value;
  set isAppbar(bool value) => _isAppbar.value = value;
  

  void upgradePlan() {
    Get.snackbar("Upgrade", "Upgrading to Bronze plan");
  }
}
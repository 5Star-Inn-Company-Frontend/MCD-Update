import 'package:get/get.dart';
import 'package:mcd/app/modules/electricity_module/electricity_module_controller.dart';
import 'package:mcd/app/modules/electricity_module/model/electricity_provider_model.dart';
import 'package:mcd/app/routes/app_pages.dart';

class ElectricityPayoutController extends GetxController {
  // --- STATE FROM ARGUMENTS ---
  late final ElectricityProvider provider;
  late final String meterNumber;
  late final double amount;
  late final String paymentType;

  // --- UI STATE ---
  final usePoints = false.obs;
  final selectedPaymentMethod = 1.obs; // 1 for Wallet, 2 for Bonus

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    provider = args['provider'] ?? ElectricityProvider(id: 0, name: 'Error', code: '');
    meterNumber = args['meterNumber'] ?? '';
    amount = args['amount'] ?? 0.0;
    paymentType = args['paymentType'] ?? '';
  }

  void toggleUsePoints(bool value) {
    usePoints.value = value;
  }

  void selectPaymentMethod(int? value) {
    if (value != null) selectedPaymentMethod.value = value;
  }

  void confirmAndPay() {
    // In a real app, you would make the final payment API call here
    Get.toNamed(
      Routes.ELECTRICITY_TRANSACTION_MODULE, // Use your named route
      arguments: {
        'providerName': provider.name,
        'amount': amount,
        'image': Get.find<ElectricityModuleController>().providerImages[provider.name],
      },
    );
  }
}
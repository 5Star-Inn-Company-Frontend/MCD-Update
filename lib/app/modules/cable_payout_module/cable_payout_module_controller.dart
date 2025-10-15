import 'package:get/get.dart';
import 'package:mcd/app/modules/cable_module/cable_module_controller.dart';
import 'package:mcd/app/modules/cable_module/model/cable_provider_model.dart';
import 'package:mcd/app/routes/app_pages.dart';

class CablePayoutController extends GetxController {
  late final CableProvider provider;
  late final String smartCardNumber;

  final usePoints = false.obs;
  final selectedPaymentMethod = 1.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    provider = args['provider'] ?? CableProvider(id: 0, name: 'Error', code: '');
    smartCardNumber = args['smartCardNumber'] ?? '';
  }

  void toggleUsePoints(bool value) {
    usePoints.value = value;
  }

  void selectPaymentMethod(int? value) {
    if (value != null) selectedPaymentMethod.value = value;
  }

  void confirmAndPay() {
    Get.toNamed(Routes.CABLE_TRANSACTION_MODULE, arguments: {
      'providerName': provider.name,
      'amount': 3950.0,
      'image': Get.find<CableModuleController>().providerImages[provider.name],
    });
  }
}
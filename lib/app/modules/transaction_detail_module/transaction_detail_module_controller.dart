import 'package:get/get.dart';

class TransactionDetailModuleController extends GetxController {
  late final String name;
  late final String image;
  late final double amount;
  late final String paymentType;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      name = arguments['name'] ?? 'Unknown Transaction';
      image = arguments['image'] ?? '';
      amount = arguments['amount'] ?? 0.0;
      paymentType = arguments['paymentType'] ?? 'Type';
    } else {
      name = 'Error: No data received';
      image = '';
      amount = 0.0;
      paymentType = 'Type';
    }
  }
}
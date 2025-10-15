import 'package:get/get.dart';

class CableTransactionController extends GetxController {
  late final String name;
  late final double amount;
  late final String image;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    name = args['providerName'] ?? 'Error';
    amount = args['amount'] ?? 0.0;
    image = args['image'] ?? '';
  }
}
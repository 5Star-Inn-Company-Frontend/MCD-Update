import 'package:get/get.dart';

class CableTransactionController extends GetxController {
  late final String name;
  late final double amount;
  late final String image;
  late final String userId;
  late final String customerName;
  late final String transactionId;
  late final String packageName;
  late final bool isRenewal;
  late final String paymentType;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    name = args['providerName'] ?? 'Error';
    amount = args['amount'] ?? 0.0;
    image = args['image'] ?? '';
    userId = args['userId'] ?? '';
    customerName = args['customerName'] ?? '';
    transactionId = args['transactionId'] ?? '';
    packageName = args['packageName'] ?? '';
    isRenewal = args['isRenewal'] ?? false;
    paymentType = args['paymentType'] ?? 'Cable TV';
  }
}
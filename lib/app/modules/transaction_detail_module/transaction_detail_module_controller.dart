import 'package:get/get.dart';
import 'dart:developer' as dev;

class TransactionDetailModuleController extends GetxController {
  late final String name;
  late final String image;
  late final double amount;
  late final String paymentType;
  late final String userId;
  late final String customerName;
  late final String transactionId;
  late final String packageName;
  late final String token;
  late final String date;

  @override
  void onInit() {
    super.onInit();
    dev.log('TransactionDetailModuleController initialized', name: 'TransactionDetail');

    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      name = arguments['name'] ?? 'Unknown Transaction';
      image = arguments['image'] ?? '';
      amount = arguments['amount'] ?? 0.0;
      paymentType = arguments['paymentType'] ?? 'Type';
      userId = arguments['userId'] ?? 'N/A';
      customerName = arguments['customerName'] ?? 'N/A';
      transactionId = arguments['transactionId'] ?? 'N/A';
      packageName = arguments['packageName'] ?? 'N/A';
      token = arguments['token'] ?? 'N/A';
      date = arguments['date'] ?? '';
      
      dev.log('Transaction details loaded - Type: $paymentType, Amount: ₦$amount, ID: $transactionId', name: 'TransactionDetail');
    } else {
      name = 'Error: No data received';
      image = '';
      amount = 0.0;
      paymentType = 'Type';
      userId = 'N/A';
      customerName = 'N/A';
      transactionId = 'N/A';
      packageName = 'N/A';
      token = 'N/A';
      date = 'N/A';

      dev.log('No transaction arguments received', name: 'TransactionDetail', error: 'Arguments missing');
    }
  }

  void copyToken() {
    if (token != 'N/A') {
      dev.log('Token copied to clipboard: $token', name: 'TransactionDetail');
    }
  }
}
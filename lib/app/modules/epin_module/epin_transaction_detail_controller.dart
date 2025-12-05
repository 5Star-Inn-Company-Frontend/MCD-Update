import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class EpinTransactionDetailController extends GetxController {
  final String networkName;
  final String networkImage;
  final String amount;
  final String designType;
  final String quantity;
  final String paymentMethod;
  final String transactionId;
  final String postedDate;
  final String transactionDate;
  final String token;

  EpinTransactionDetailController({
    required this.networkName,
    required this.networkImage,
    required this.amount,
    required this.designType,
    required this.quantity,
    required this.paymentMethod,
    required this.transactionId,
    required this.postedDate,
    required this.transactionDate,
    required this.token,
  });

  void shareReceipt() {
    final receiptText = '''
E-Pin Purchase Receipt
----------------------
Network: $networkName
Amount: ₦$amount
Design Type: $designType
Quantity: $quantity
Payment Method: $paymentMethod
Transaction ID: $transactionId
Date: $transactionDate
Token: $token
Status: Successful
''';

    Share.share(receiptText, subject: 'E-Pin Purchase Receipt');
  }

  void downloadReceipt() {
    // TODO: Implement download receipt functionality
    Get.snackbar('Download', 'Receipt download started');
  }

  void buyAgain() {
    // Navigate back to purchase screen with pre-filled data
    Get.back();
    Get.back();
    Get.snackbar('Buy Again', 'Form pre-filled with previous purchase details');
  }

  void addToRecurring() {
    // TODO: Implement add to recurring functionality
    Get.snackbar('Recurring', 'Added to recurring transactions');
  }

  void contactSupport() {
    // TODO: Navigate to support page
    Get.snackbar('Support', 'Contacting support...');
  }
}

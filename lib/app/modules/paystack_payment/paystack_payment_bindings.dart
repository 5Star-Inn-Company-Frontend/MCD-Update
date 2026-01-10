import 'package:get/get.dart';
import 'paystack_payment_controller.dart';

class PaystackPaymentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaystackPaymentController>(() => PaystackPaymentController());
  }
}

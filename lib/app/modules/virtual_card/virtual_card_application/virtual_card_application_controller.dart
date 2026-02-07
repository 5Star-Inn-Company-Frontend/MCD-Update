import 'package:get/get.dart';
import 'package:mcd/app/modules/virtual_card/models/created_card_model.dart';

class VirtualCardApplicationController extends GetxController {
  final cardData = Rxn<CreatedCardModel>();
  final isNumberVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    // get card data from arguments
    final args = Get.arguments;
    if (args != null && args['cardData'] != null) {
      cardData.value = args['cardData'] as CreatedCardModel;
    }
  }

  // toggles visibility of card number
  void toggleNumberVisibility() {
    isNumberVisible.value = !isNumberVisible.value;
  }

  // get display card number (masked or full)
  String get displayCardNumber {
    if (cardData.value == null) return '';
    return isNumberVisible.value
        ? cardData.value!.number
        : cardData.value!.masked;
  }
}

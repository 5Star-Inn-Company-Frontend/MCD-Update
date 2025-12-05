import 'package:get/get.dart';

class VirtualCardFullDetailsController extends GetxController {
  final isDetailsVisible = false.obs;
  
  void toggleDetails() {
    print('toggleDetails called. Current value: ${isDetailsVisible.value}');
    isDetailsVisible.value = !isDetailsVisible.value;
    print('New value: ${isDetailsVisible.value}');
    update(); // Force update
  }
}

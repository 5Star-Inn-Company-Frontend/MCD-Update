import 'package:get/get.dart';
import './country_selection_controller.dart';

class CountrySelectionBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CountrySelectionController>(() => CountrySelectionController());
  }
}

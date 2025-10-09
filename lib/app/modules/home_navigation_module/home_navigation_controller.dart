import 'package:get/get.dart';

import '../../../features/home/presentation/views/assistant_screen.dart';
import '../../../features/home/presentation/views/history_screen.dart';
import '../../../features/home/presentation/views/home_screen.dart';
import '../../../features/home/presentation/views/more_screen.dart';
import '../../../features/shop/presentation/views/shop_screen.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class HomeNavigationController extends GetxController {
  var _obj = ''.obs;
  set obj(value) => _obj.value = value;
  get obj => _obj.value;

  final tabs = [
    const HomeScreen(),
    const HistoryScreen(),
    const ShopScreen(),
    const AssistantScreen(),
    const MoreProfileScreen()
  ];

  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;
  set selectedIndex(int value) => _selectedIndex.value = value;

  void onItemTapped(int index) {
    selectedIndex = index;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments) {
      selectedIndex = Get.arguments.toInt();
      onItemTapped(selectedIndex);
    } else {
      onItemTapped(selectedIndex);
    }
  }
}

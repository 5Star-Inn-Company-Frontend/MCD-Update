import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import '../models/giveaway_model.dart';
import '../giveaway_module_controller.dart';

class GiveawayDetailController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();

  final detail = Rxn<GiveawayDetailModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments?['id'];
    if (id != null) {
      fetchDetail(id);
    } else {
      Get.back();
      Get.snackbar('Error', 'Invalid giveaway ID');
    }
  }

  Future<void> fetchDetail(int id) async {
    try {
      isLoading.value = true;
      if (Get.isRegistered<GiveawayModuleController>()) {
        final mainController = Get.find<GiveawayModuleController>();
        final response = await mainController.fetchGiveawayDetail(id);
        if (response != null) {
          detail.value = response;
        }
      } else {
        // Fallback if main controller not yet registered
        dev.log('GiveawayModuleController not registered',
            name: 'GiveawayDetail');
      }
    } catch (e) {
      dev.log('Error fetching details: $e', name: 'GiveawayDetail');
    } finally {
      isLoading.value = false;
    }
  }

  void claimGiveaway() {
    if (detail.value == null) return;

    // We can reuse the claim logic from GiveawayModuleController if it's registered
    if (Get.isRegistered<GiveawayModuleController>()) {
      final mainController = Get.find<GiveawayModuleController>();
      mainController.showAdClaimDialogFirst(
        detail.value!.giveaway.id,
        detail.value!.giveaway.type,
        Get.context!,
      );
    } else {
      Get.snackbar('Error', 'Giveaway service error');
    }
  }
}

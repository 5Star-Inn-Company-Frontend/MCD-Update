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
    final dynamic rawId = Get.arguments?['id'] ?? Get.arguments?['giveaway_id'];
    final int? id = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '');
    final autoClaim = Get.arguments?['auto_claim'] ?? false;

    if (id != null) {
      fetchDetail(id).then((_) {
        if (autoClaim) {
          claimGiveaway();
        }
      });
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

    final currentUsername = box.read('biometric_username_real') ?? '';
    final isOwnGiveaway =
        detail.value!.giveaway.userName.trim().toLowerCase() ==
            currentUsername.trim().toLowerCase();
    if (isOwnGiveaway) {
      Get.snackbar('Not allowed', "You can't claim your own giveaway");
      return;
    }

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

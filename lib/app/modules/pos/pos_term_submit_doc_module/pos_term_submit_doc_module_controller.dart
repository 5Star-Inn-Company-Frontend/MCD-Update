import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosTermSubmitDocModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  final selectedFileName = ''.obs;
  final fileUploaded = false.obs;

  void selectFile(String fileName) {
    selectedFileName.value = fileName;
    fileUploaded.value = true;
  }

  void submitDocument() {
    // TODO: Implement document submission logic
    dev.log('Document submitted: ${selectedFileName.value}', name: 'PosTermSubmitDoc');
  }

  @override
  void onInit() {
    super.onInit();
    dev.log('PosTermSubmitDocModuleController initialized', name: 'PosTermSubmitDoc');
  }

  @override
  void onClose() {
    dev.log('PosTermSubmitDocModuleController disposed', name: 'PosTermSubmitDoc');
    super.onClose();
  }
}

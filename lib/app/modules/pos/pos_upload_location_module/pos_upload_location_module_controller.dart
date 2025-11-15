import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class PosUploadLocationModuleController extends GetxController {
  final apiService = DioApiService();
  final box = GetStorage();
  
  final isLoading = false.obs;
  final selectedFileName = ''.obs;
  final fileUploaded = false.obs;

  void selectFile(String fileName) {
    selectedFileName.value = fileName;
    fileUploaded.value = true;
  }

  void proceedToAgreement() {
    // TODO: Implement file upload logic
    dev.log('Image uploaded: ${selectedFileName.value}', name: 'PosUploadLocation');
  }

  @override
  void onInit() {
    super.onInit();
    dev.log('PosUploadLocationModuleController initialized', name: 'PosUploadLocation');
  }

  @override
  void onClose() {
    dev.log('PosUploadLocationModuleController disposed', name: 'PosUploadLocation');
    super.onClose();
  }
}

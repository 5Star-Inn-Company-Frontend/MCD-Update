import 'dart:io';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'dart:developer' as dev;

class ScanQrcodeModuleController extends GetxController {
  QRViewController? qrController;

  final _result = Rxn<String>();
  String? get result => _result.value;

  final _isProcessing = false.obs;
  bool get isProcessing => _isProcessing.value;

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;

    
    controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) {
      
      if (_isProcessing.value) return;

      
      if (scanData.code != null && scanData.code!.isNotEmpty) {
        _isProcessing.value = true;
        _result.value = scanData.code;
        qrController?.pauseCamera();

        dev.log('QR Code scanned: ${scanData.code}', name: 'QRScanner');

        
        String scannedUsername = scanData.code!.trim();

        
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offNamed(
            Routes.QRCODE_TRANSFER_DETAILS_MODULE,
            arguments: {
              'username': scannedUsername,
            },
          );
        });
      }
    });
  }

  void reassemble() {
    if (Platform.isAndroid) {
      qrController?.pauseCamera();
    }
    qrController?.resumeCamera();
  }

  @override
  void onClose() {
    qrController?.dispose();
    super.onClose();
  }
}

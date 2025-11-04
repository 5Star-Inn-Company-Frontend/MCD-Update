import 'dart:io';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanQrcodeModuleController extends GetxController {
  QRViewController? qrController;

  final _result = Rxn<String>();
  String? get result => _result.value;

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) {
      _result.value = scanData.code;
      
      // Navigate to transfer details when QR is scanned
      if (scanData.code != null) {
        qrController?.pauseCamera();
        Get.offNamed(
          Routes.QRCODE_TRANSFER_DETAILS_MODULE,
          arguments: {
            'username': scanData.code,
            'email': 'scanned@example.com',
          },
        );
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

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as dev;

class QrcodeRequestFundDetailsModuleController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Global key for capturing QR code
  final qrKey = GlobalKey();

  // Text editing controller
  final amountController = TextEditingController();

  // Scanned user data
  final _scannedUsername = ''.obs;
  String get scannedUsername => _scannedUsername.value;

  final _scannedEmail = ''.obs;
  String get scannedEmail => _scannedEmail.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    // Load scanned user data from arguments
    final args = Get.arguments;
    if (args != null) {
      _scannedUsername.value = args['username'] ?? 'Tesd';
      _scannedEmail.value = args['email'] ?? 'admin@5starcompany.com.ng';
    } else {
      // Default values for testing
      _scannedUsername.value = 'Tesd';
      _scannedEmail.value = 'admin@5starcompany.com.ng';
    }
  }

  // Request fund with QR code save and share
  Future<void> requestFund() async {
    if (!formKey.currentState!.validate()) return;

    try {
      _isLoading.value = true;

      final amount = double.tryParse(amountController.text) ?? 0.0;

      if (amount <= 0) {
        Get.snackbar(
          'Error',
          'Please enter a valid amount',
          backgroundColor: AppColors.errorBgColor,
          colorText: AppColors.textSnackbarColor,
        );
        return;
      }

      dev.log('Requesting fund of ₦$amount from $scannedUsername', name: 'RequestFund');

      // Capture and save QR code
      await _captureAndShareQRCode(amount);

      // TODO: Implement actual request fund API call here if needed

      Get.snackbar(
        'Success',
        'QR code saved and ready to share',
        backgroundColor: AppColors.successBgColor,
        colorText: AppColors.textSnackbarColor,
      );

      // Navigate back after successful save
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    } catch (e) {
      dev.log('Error requesting fund', name: 'RequestFund', error: e);
      Get.snackbar(
        'Error',
        'Request failed: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Capture QR code as image and share
  Future<void> _captureAndShareQRCode(double amount) async {
    try {
      dev.log('Capturing QR code for fund request', name: 'RequestFund');
      
      final boundary = qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Unable to capture QR code');
      }
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      
      // Save to device storage
      String? savedPath;
      if (Platform.isAndroid) {
        PermissionStatus status = await Permission.photos.status;
        
        if (!status.isGranted) {
          status = await Permission.photos.request();
          
          if (!status.isGranted) {
            status = await Permission.storage.status;
            if (!status.isGranted) {
              status = await Permission.storage.request();
            }
          }
        }
        
        if (status.isPermanentlyDenied) {
          Get.snackbar(
            'Permission Required',
            'Please enable storage permission in Settings',
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
            duration: const Duration(seconds: 3),
            mainButton: TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Settings', style: TextStyle(color: Colors.white)),
            ),
          );
          throw Exception('Storage permission denied');
        }
        
        if (!status.isGranted) {
          throw Exception('Storage permission is required');
        }
        
        // Save to Downloads folder
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        final file = File('${directory.path}/MCD_FundRequest_${scannedUsername}_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(pngBytes);
        savedPath = file.path;
        dev.log('QR code saved to: $savedPath', name: 'RequestFund');
      } else {
        // For iOS or other platforms
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/MCD_FundRequest_${scannedUsername}_${DateTime.now().millisecondsSinceEpoch}.png');
        await file.writeAsBytes(pngBytes);
        savedPath = file.path;
      }
      
      // Share the QR code
      await Share.shareXFiles(
        [XFile(savedPath)],
        text: 'Fund Request - ₦${amount.toStringAsFixed(2)} from @$scannedUsername',
      );
      
      dev.log('QR code saved and shared successfully', name: 'RequestFund');
    } catch (e) {
      dev.log('Error capturing and sharing QR code', name: 'RequestFund', error: e);
      rethrow;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}

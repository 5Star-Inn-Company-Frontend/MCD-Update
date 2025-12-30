import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/network/dio_api_service.dart';
import 'dart:developer' as dev;

class TransactionDetailModuleController extends GetxController {
  var apiService = DioApiService();
  final box = GetStorage();
  
  // Global key for capturing receipt screenshot
  final receiptKey = GlobalKey();

  late final String name;
  late final String image;
  late final double amount;
  late final String paymentType;
  late final String paymentMethod;
  late final String userId;
  late final String customerName;
  late final String transactionId;
  late final String packageName;
  late final String token;
  late final String date;

  final _isRepeating = false.obs;
  bool get isRepeating => _isRepeating.value;
  
  final _isSharing = false.obs;
  bool get isSharing => _isSharing.value;
  
  final _isDownloading = false.obs;
  bool get isDownloading => _isDownloading.value;

  @override
  void onInit() {
    super.onInit();
    dev.log('TransactionDetailModuleController initialized', name: 'TransactionDetail');

    final arguments = Get.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      name = arguments['name'] ?? 'Unknown Transaction';
      image = arguments['image'] ?? '';
      amount = arguments['amount'] ?? 0.0;
      paymentType = arguments['paymentType'] ?? 'Type';
      paymentMethod = arguments['paymentMethod'] ?? 'Wallet';
      userId = arguments['userId'] ?? 'N/A';
      customerName = arguments['customerName'] ?? 'N/A';
      transactionId = arguments['transactionId'] ?? 'N/A';
      packageName = arguments['packageName'] ?? 'N/A';
      token = arguments['token'] ?? 'N/A';
      date = arguments['date'] ?? '';
      
      dev.log('Transaction details loaded - Type: $paymentType, Amount: ₦$amount, ID: $transactionId, Payment Method: $paymentMethod', name: 'TransactionDetail');
    } else {
      name = 'Error: No data received';
      image = 'assets/images/mcdlogo.png';
      amount = 0.0;
      paymentType = 'Type';
      paymentMethod = 'Payment Method';
      userId = 'N/A';
      customerName = 'N/A';
      transactionId = 'N/A';
      packageName = 'N/A';
      token = 'N/A';
      date = 'N/A';

      dev.log('No transaction arguments received', name: 'TransactionDetail', error: 'Arguments missing');
    }
  }

  void copyToken() {
    if (token != 'N/A') {
      dev.log('Token copied to clipboard: $token', name: 'TransactionDetail');
    }
  }

  // Repeat transaction (Buy Again)
  Future<void> repeatTransaction() async {
    if (transactionId == 'N/A' || transactionId.isEmpty) {
      Get.snackbar(
        'Error',
        'Cannot repeat transaction: Invalid transaction ID',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    try {
      _isRepeating.value = true;
      dev.log('Repeating transaction: $transactionId', name: 'TransactionDetail');

      final transactionUrl = box.read('transaction_service_url') ?? '';
      final url = '${transactionUrl}transaction/repeat';
      dev.log('Repeat URL: $url', name: 'TransactionDetail');

      final body = {
        'ref': transactionId,
      };

      final response = await apiService.postrequest(url, body);

      response.fold(
        (failure) {
          dev.log('Failed to repeat transaction', name: 'TransactionDetail', error: failure.message);
          Get.snackbar(
            'Error',
            failure.message,
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
            duration: const Duration(seconds: 2),
          );
        },
        (data) {
          dev.log('Repeat transaction response: $data', name: 'TransactionDetail');
          if (data['success'] == 1) {
            Get.snackbar(
              'Success',
              data['message'] ?? 'Transaction repeated successfully',
              backgroundColor: AppColors.successBgColor,
              colorText: AppColors.textSnackbarColor,
              duration: const Duration(seconds: 2),
            );
            // Navigate back after successful repeat
            Future.delayed(const Duration(seconds: 2), () {
              Get.back();
            });
          } else {
            Get.snackbar(
              'Error',
              data['message'] ?? 'Failed to repeat transaction',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
              duration: const Duration(seconds: 2),
            );
          }
        },
      );
    } catch (e) {
      dev.log('Error repeating transaction', name: 'TransactionDetail', error: e);
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _isRepeating.value = false;
    }
  }
  
  // Capture receipt as image and share
  Future<void> shareReceipt() async {
    try {
      _isSharing.value = true;
      dev.log('Sharing receipt', name: 'TransactionDetail');
      
      final boundary = receiptKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Unable to capture receipt');
      }
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      
      // Save to temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/receipt_$transactionId.png');
      await file.writeAsBytes(pngBytes);
      
      dev.log('Receipt saved to: ${file.path}', name: 'TransactionDetail');
      
      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Transaction Receipt - $paymentType - ₦$amount',
      );
      
      dev.log('Receipt shared successfully', name: 'TransactionDetail');
    } catch (e) {
      dev.log('Error sharing receipt', name: 'TransactionDetail', error: e);
      Get.snackbar(
        'Error',
        'Failed to share receipt: $e',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _isSharing.value = false;
    }
  }
  
  // Download receipt to device storage
  Future<void> downloadReceipt() async {
    try {
      _isDownloading.value = true;
      dev.log('Downloading receipt', name: 'TransactionDetail');
      
      // Handle permissions for different platforms
      if (Platform.isAndroid) {
        PermissionStatus status;
        
        // Try photos permission first (works for Android 13+)
        status = await Permission.photos.status;
        
        if (!status.isGranted) {
          status = await Permission.photos.request();
          
          // If photos permission is not available, try storage (Android 12 and below)
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
            'Please enable storage permission in Settings to download receipts',
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
            duration: const Duration(seconds: 3),
            mainButton: TextButton(
              onPressed: () => openAppSettings(),
              child: const Text('Settings', style: TextStyle(color: Colors.white)),
            ),
          );
          return;
        }
        
        if (status.isDenied) {
          Get.snackbar(
            'Permission Denied',
            'Storage permission is required to download receipt',
            backgroundColor: AppColors.errorBgColor,
            colorText: AppColors.textSnackbarColor,
            duration: const Duration(seconds: 2),
          );
          return;
        }
      } else if (Platform.isIOS) {
        // Check and request photo library permission for iOS
        final status = await Permission.photos.status;
        
        if (!status.isGranted) {
          final requested = await Permission.photos.request();
          
          if (requested.isPermanentlyDenied) {
            Get.snackbar(
              'Permission Required',
              'Please enable photo library access in Settings to download receipts',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
              duration: const Duration(seconds: 3),
              mainButton: TextButton(
                onPressed: () => openAppSettings(),
                child: const Text('Settings', style: TextStyle(color: Colors.white)),
              ),
            );
            return;
          }
          
          if (requested.isDenied) {
            Get.snackbar(
              'Permission Denied',
              'Photo library access is required to download receipt',
              backgroundColor: AppColors.errorBgColor,
              colorText: AppColors.textSnackbarColor,
              duration: const Duration(seconds: 2),
            );
            return;
          }
        }
      }
      
      final boundary = receiptKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception('Unable to capture receipt');
      }
      
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      
      // Save to appropriate directory based on platform
      Directory? directory;
      String fileName;
      
      if (Platform.isAndroid) {
        // Try to save to public Downloads folder
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          // Fallback to Documents folder
          directory = Directory('/storage/emulated/0/Documents');
          if (!await directory.exists()) {
            // Final fallback to app-specific external storage
            directory = await getExternalStorageDirectory();
          }
        }
        
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        fileName = 'Receipt_${transactionId}_$timestamp.png';
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        fileName = 'Receipt_${transactionId}_$timestamp.png';
      } else {
        directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        fileName = 'Receipt_${transactionId}_$timestamp.png';
      }
      
      if (directory == null) {
        throw Exception('Unable to access storage');
      }
      // Ensure the directory exists (create if necessary)
      try {
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
      } catch (e) {
        dev.log('Failed to create directory: ${directory.path}', name: 'TransactionDetail', error: e);
      }

      File file = File('${directory.path}/$fileName');

      try {
        await file.writeAsBytes(pngBytes);
      } on FileSystemException catch (e) {
        dev.log('Primary save failed, attempting fallback', name: 'TransactionDetail', error: e);

        // Fallback: save to app documents directory
        final fallbackDir = await getApplicationDocumentsDirectory();
        if (!await fallbackDir.exists()) {
          await fallbackDir.create(recursive: true);
        }
        final fallbackFile = File('${fallbackDir.path}/$fileName');
        await fallbackFile.writeAsBytes(pngBytes);
        file = fallbackFile;
      }

      dev.log('Receipt saved to: ${file.path}', name: 'TransactionDetail');

      String? savedLocation;
      // If Android, attempt to move the file into Downloads via MediaStore
      if (Platform.isAndroid) {
        try {
          const channel = MethodChannel('mcd.storage/channel');
          final result = await channel.invokeMethod<String>('saveFileToDownloads', {
            'sourcePath': file.path,
            'displayName': fileName,
            'mimeType': 'image/png',
          });

          if (result != null && result.isNotEmpty) {
            savedLocation = result; // This will be a content URI string on success
          }
        } catch (e) {
          dev.log('MediaStore save failed, keeping original file: ${file.path}', name: 'TransactionDetail', error: e);
        }
      }

      final displayPath = savedLocation ?? file.path;
      Get.snackbar(
        'Saved',
        'Receipt saved: $displayPath',
        backgroundColor: AppColors.successBgColor,
        colorText: AppColors.textSnackbarColor,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      dev.log('Download failed', name: 'TransactionDetail', error: e);
      Get.snackbar(
        'Download Failed',
        'Unable to download receipt: ${e.toString()}',
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        duration: const Duration(seconds: 2),
      );
    } finally {
      _isDownloading.value = false;
    }
  }
}
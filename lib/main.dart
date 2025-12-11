import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcd/app/app.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer' as dev;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await MobileAds.instance.initialize();

  // Request storage/photo permissions on app startup
  await _requestStoragePermissions();

  Get.put(LoginScreenController());
  runApp(McdApp());
}

/// Request storage permissions based on platform and Android API level
Future<void> _requestStoragePermissions() async {
  try {
    if (Platform.isAndroid) {
      // Check Android API level
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      
      // For Android 13+ (API 33+), use photos permission
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.photos.request();
        dev.log('Android 13+ photos permission: $status', name: 'Permissions');
        
        // If denied, also try media images
        if (status.isDenied || status.isPermanentlyDenied) {
          await Permission.mediaLibrary.request();
        }
      } else {
        // For Android 12 and below, use storage permission
        final status = await Permission.storage.request();
        dev.log('Android 12- storage permission: $status', name: 'Permissions');
      }
    } else if (Platform.isIOS) {
      // Request photo library permission for iOS
      final status = await Permission.photos.request();
      dev.log('iOS photos permission: $status', name: 'Permissions');
    }
  } catch (e) {
    dev.log('Error requesting storage permissions', error: e, name: 'Permissions');
  }
}
 
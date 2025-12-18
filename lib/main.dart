import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcd/app/app.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/services/connectivity_service.dart';
import 'package:mcd/core/controllers/service_status_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer' as dev;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await MobileAds.instance.initialize();
  await _requestStoragePermissions();

  await Get.putAsync(() async => ConnectivityService());
  
  Get.put(ServiceStatusController());  
  Get.put(LoginScreenController());
  runApp(McdApp());
}

/// request storage permissions based on platform and android api level
Future<void> _requestStoragePermissions() async {
  try {
    if (Platform.isAndroid) {
      // check Android API level
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.photos.request();
        dev.log('Android 13+ photos permission: $status', name: 'Permissions');
        
        if (status.isDenied || status.isPermanentlyDenied) {
          await Permission.mediaLibrary.request();
        }
      } else {
        final status = await Permission.storage.request();
        dev.log('Android 12- storage permission: $status', name: 'Permissions');
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      dev.log('iOS photos permission: $status', name: 'Permissions');
    }
  } catch (e) {
    dev.log('Error requesting storage permissions', error: e, name: 'Permissions');
  }
}
 
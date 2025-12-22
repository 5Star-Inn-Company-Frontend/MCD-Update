import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcd/app/app.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/services/connectivity_service.dart';
import 'package:mcd/core/controllers/service_status_controller.dart';
import 'package:mcd/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:developer' as dev;

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  dev.log('Handling background message: ${message.messageId}', name: 'FCM');
  
  if (message.notification != null) {
    dev.log('Background notification: ${message.notification!.title}', name: 'FCM');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Request notification permissions
  await _requestNotificationPermissions();
  
  await GetStorage.init();
  await MobileAds.instance.initialize();
  await _requestStoragePermissions();

  await Get.putAsync(() async => ConnectivityService());
  
  Get.put(ServiceStatusController());  
  Get.put(LoginScreenController());
  
  // Set up foreground message handling
  _setupForegroundMessageHandler();
  
  runApp(McdApp());
}

/// Request notification permissions
Future<void> _requestNotificationPermissions() async {
  try {
    final messaging = FirebaseMessaging.instance;
    
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    dev.log('Notification permission status: ${settings.authorizationStatus}', name: 'FCM');
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      dev.log('User granted notification permission', name: 'FCM');
      
      // Get FCM token
      final token = await messaging.getToken();
      dev.log('FCM Token: $token', name: 'FCM');
      
      // You can save this token to your backend if needed
      // await saveTokenToBackend(token);
    } else {
      dev.log('User declined or has not accepted notification permission', name: 'FCM');
    }
  } catch (e) {
    dev.log('Error requesting notification permissions', error: e, name: 'FCM');
  }
}

/// Setup foreground message handler
void _setupForegroundMessageHandler() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    dev.log('Foreground message received: ${message.messageId}', name: 'FCM');
    
    if (message.notification != null) {
      dev.log('Notification: ${message.notification!.title} - ${message.notification!.body}', name: 'FCM');
      
      // Show in-app notification
      Get.snackbar(
        message.notification!.title ?? 'Notification',
        message.notification!.body ?? '',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(10),
        backgroundColor: Get.theme.primaryColor.withOpacity(0.9),
        colorText: Colors.white,
        icon: const Icon(Icons.notifications, color: Colors.white),
      );
    }
    
    // Handle data payload
    if (message.data.isNotEmpty) {
      dev.log('Data: ${message.data}', name: 'FCM');
      _handleNotificationData(message.data);
    }
  });
  
  // Handle notification tap when app is in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    dev.log('Notification tapped (app in background): ${message.messageId}', name: 'FCM');
    
    if (message.data.isNotEmpty) {
      _handleNotificationData(message.data);
    }
  });
  
  // Check if app was opened from a terminated state via notification
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      dev.log('App opened from terminated state via notification: ${message.messageId}', name: 'FCM');
      
      if (message.data.isNotEmpty) {
        _handleNotificationData(message.data);
      }
    }
  });
}

/// Handle notification data and navigate accordingly
void _handleNotificationData(Map<String, dynamic> data) {
  try {
    final type = data['type'];
    
    if (type == 'giveaway') {
      // Navigate to giveaway page
      final giveawayId = data['giveaway_id'];
      dev.log('Navigating to giveaway: $giveawayId', name: 'FCM');
      
      // Use Get.toNamed when your route is ready
      // Get.toNamed(Routes.GIVEAWAY_MODULE, arguments: {'id': giveawayId});
    }
  } catch (e) {
    dev.log('Error handling notification data', error: e, name: 'FCM');
  }
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
 
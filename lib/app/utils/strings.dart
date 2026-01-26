import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:permission_handler/permission_handler.dart';

/**
 * GetX Template Generator - fb.com/htngu.99
 * */

String home = 'Home';

Future<String?> contactpicked() async {
  if (await Permission.contacts.request().isGranted) {
    final FlutterNativeContactPicker _contactPicker =
    FlutterNativeContactPicker();
    Contact? contact = await _contactPicker.selectContact();
    var array = contact!.phoneNumbers;
    return array
        .toString()
        .replaceAll(" ", "")
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("+234", "0")
        .replaceAll("234", "0");
  } else {
    requestPermission();
  }
  return null;
}



requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.camera,
    Permission.contacts,
    Permission.microphone,
    // Permission.location
  ].request();

  final info = statuses[Permission.storage].toString();
  // _toastInfo(info);
}
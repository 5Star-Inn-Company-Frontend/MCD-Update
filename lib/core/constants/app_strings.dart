import 'package:get_storage/get_storage.dart';

final box = GetStorage();

class AppStrings {
  static const appNAme = "Mega Cheap Data";
  static const emptyString = "is empty, please input data";

  static String get ref {
    final username = box.read('biometric_username_real') ?? 'MCD';
    final userPrefix = username.length >= 3
        ? username.substring(0, 3).toUpperCase()
        : username.toUpperCase();
    return 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';
  }
}

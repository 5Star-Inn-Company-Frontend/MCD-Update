import 'package:get_storage/get_storage.dart';


final box = GetStorage();
final username = box.read('biometric_username_real') ?? 'MCD';
final userPrefix = username.length >= 3 ? username.substring(0, 3).toUpperCase() : username.toUpperCase();
final reference = 'MCD2_$userPrefix${DateTime.now().microsecondsSinceEpoch}';

class AppStrings {
  static const appNAme = "Mega Cheap Data";
  static const emptyString = "is empty, please input data";

  static final ref = reference;
}

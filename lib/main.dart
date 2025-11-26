import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mcd/app/app.dart';
import 'package:mcd/core/import/imports.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await MobileAds.instance.initialize();

  Get.put(LoginScreenController());
  runApp(McdApp());
}

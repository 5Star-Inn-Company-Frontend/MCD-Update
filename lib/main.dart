import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/app.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/network/api_constants.dart';
// import 'package:mcd/core/network/api_service.dart';
import 'package:mcd/core/utils/aes_helper.dart';
import 'package:mcd/features/auth/data/providers/auth_api_provider.dart';
import 'package:mcd/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mcd/features/auth/domain/repositories/auth_repository.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(McdApp());
}

import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/app.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/network/api_constants.dart';
import 'package:mcd/core/utils/aes_helper.dart';
import 'package:mcd/features/auth/data/providers/auth_api_provider.dart';
import 'package:mcd/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mcd/features/auth/domain/repositories/auth_repository.dart';
import 'package:mcd/features/auth/presentation/controllers/auth_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize API and services
  final authApiProvider = Get.put(AuthApiProvider());
  final aesHelper = Get.put(AESHelper(ApiConstants.encryptionKey));
  final authRepository =
  Get.put<AuthRepository>(AuthRepositoryImpl(authApiProvider, aesHelper));
  Get.put(AuthController(authRepository));
  Get.put(LoginScreenController());
  runApp(McdApp());
}

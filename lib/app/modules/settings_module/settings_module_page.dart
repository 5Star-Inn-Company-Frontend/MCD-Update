import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mcd/core/import/imports.dart';
import './settings_module_controller.dart';
import '../login_screen_module/login_screen_controller.dart';

class SettingsModulePage extends GetView<SettingsModuleController> {
    
  const SettingsModulePage({super.key});

  Widget rowcard({
    required String name,
    required VoidCallback onTap,
    required bool isSwitch,
    bool value = false,
    ValueChanged<bool>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TouchableOpacity(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryGrey, width: 0.5),
            color: AppColors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                TextSemiBold(name),
                const Spacer(),
                isSwitch
                    ? Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: value,
                          activeColor: AppColors.primaryGreen,
                          inactiveThumbColor: AppColors.white,
                          trackOutlineColor: MaterialStateProperty.all(AppColors.white),
                          onChanged: onChanged,
                        ),
                      )
                    : SvgPicture.asset(AppAsset.arrowRight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        centerTitle: false,
        title: "Settings",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const Gap(20),
              rowcard(
                name: 'Change Password',
                onTap: () {
                  Get.toNamed(Routes.CHANGE_PWD_MODULE);
                },
                isSwitch: false,
              ),
              
              rowcard(
                name: 'Change pin',
                onTap: () {
                  Get.toNamed(Routes.CHANGE_PIN_MODULE);
                },
                isSwitch: false,
              ),
              
              Obx(() => rowcard(
                name: 'Use biometrics to login',
                onTap: () {},
                isSwitch: true,
                value: controller.biometrics.value,
                onChanged: (val) async {
                  controller.biometrics.value = val;
                  await controller.box.write('biometric_enabled', val);

                  if (!val) {
                    // clear saved credentials when disabling biometric
                    const secureStorage = FlutterSecureStorage();
                    await controller.box.remove('biometric_username');
                    await secureStorage.delete(key: 'biometric_password');
                  }

                  // update login controller biometric setup status if it exists
                  if (Get.isRegistered<LoginScreenController>()) {
                    final loginController = Get.find<LoginScreenController>();
                    loginController.checkBiometricSetup();
                  }

                  Get.snackbar(
                    "Biometric Login",
                    val
                        ? "Enabled fingerprint login. Please login with your credentials to complete setup."
                        : "Disabled fingerprint login",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: AppColors.successBgColor,
                    colorText: AppColors.textSnackbarColor,
                    duration: const Duration(seconds: 3),
                  );
                },
              )),
              
              Obx(() => rowcard(
                name: '2FA',
                onTap: () {},
                isSwitch: true,
                value: controller.twoFA.value,
                onChanged: (val) {
                  controller.twoFA.value = val;
                },
              )),
              
              Obx(() => rowcard(
                name: 'Give away notification',
                onTap: () {},
                isSwitch: true,
                value: controller.giveaway.value,
                onChanged: (val) {
                  controller.saveGiveawaySetting(val);
                },
              )),
              
              Obx(() => rowcard(
                name: 'Promo code',
                onTap: () {},
                isSwitch: true,
                value: controller.promo.value,
                onChanged: (val) {
                  controller.savePromoSetting(val);
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
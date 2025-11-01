import 'package:mcd/core/import/imports.dart';
import './settings_module_controller.dart';

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
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => const ChangePasswordScreen(),
                  // ));
                },
                isSwitch: false,
              ),
              
              rowcard(
                name: 'Change pin',
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => const ChangePinScreen(),
                  // ));
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

                  Get.snackbar(
                    "Biometric Login",
                    val
                        ? "Enabled fingerprint login"
                        : "Disabled fingerprint login",
                    snackPosition: SnackPosition.BOTTOM,
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
                  controller.giveaway.value = val;
                },
              )),
              
              Obx(() => rowcard(
                name: 'Promo code',
                onTap: () {},
                isSwitch: true,
                value: controller.promo.value,
                onChanged: (val) {
                  controller.promo.value = val;
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
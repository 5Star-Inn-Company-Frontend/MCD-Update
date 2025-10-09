import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/features/home/presentation/views/change_password.dart';
import 'package:mcd/features/home/presentation/views/change_pin_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final box = GetStorage();

  bool biometrics = false;
  bool twoFA = false;
  bool giveaway = false;
  bool promo = false;

  @override
  void initState() {
    super.initState();
    biometrics = box.read('biometric_enabled') ?? false;
  }

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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ));
                },
                isSwitch: false,
              ),
              rowcard(
                name: 'Change pin',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChangePinScreen(),
                  ));
                },
                isSwitch: false,
              ),
              
              rowcard(
                name: 'Use biometrics to login',
                onTap: () {},
                isSwitch: true,
                value: biometrics,
                onChanged: (val) async {
                  setState(() => biometrics = val);
                  await box.write('biometric_enabled', val);

                  Get.snackbar(
                    "Biometric Login",
                    val
                        ? "Enabled fingerprint login"
                        : "Disabled fingerprint login",
                    snackPosition: SnackPosition.TOP,
                  );
                },
              ),
              
              rowcard(
                name: '2FA',
                onTap: () {},
                isSwitch: true,
                value: twoFA,
                onChanged: (val) {
                  setState(() => twoFA = val);
                },
              ),
              
              rowcard(
                name: 'Give away notification',
                onTap: () {},
                isSwitch: true,
                value: giveaway,
                onChanged: (val) {
                  setState(() => giveaway = val);
                },
              ),
              
              rowcard(
                name: 'Promo code',
                onTap: () {},
                isSwitch: true,
                value: promo,
                onChanged: (val) {
                  setState(() => promo = val);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

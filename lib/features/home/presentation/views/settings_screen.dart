import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
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
  bool biometrics = false;

  Widget rowcard(
    String name,
    VoidCallback onTap,
    bool isSwitch,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TouchableOpacity(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryGrey, width: 0.5),
              color: AppColors.white,
              borderRadius: BorderRadius.circular(3)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                TextSemiBold(name),
                const Spacer(),
                isSwitch == true
                    ? Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: biometrics,
                          activeColor: AppColors.primaryGreen,
                          onChanged: (bool value) {
                            setState(() {
                              biometrics = value;
                            });
                          },
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
        // elevation: 2,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            const Gap(20),
            rowcard(
              'Change Password',
              () {
                     Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen()));
              },
              false,
            ),
            rowcard(
              'Change pin',
              () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ChangePinScreen()));
              },
              false,
            ),
            rowcard(
              'Use biometrics to login',
              () {},
              true,
            ),
            rowcard(
              '2FA',
              () {},
              true,
            ),
            rowcard(
              'Give away notification',
              () {},
              true,
            ),
            rowcard(
              'Promo code',
              () {},
              true,
            ),
          ],
        ),
      )),
    );
  }
}

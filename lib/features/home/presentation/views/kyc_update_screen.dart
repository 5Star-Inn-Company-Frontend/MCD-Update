import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/textField.dart';
// import 'package:sprint_check/sprint_check.dart';
// import 'package:sprint_check/sprint_check_method_channel.dart';

class KycUpdateScreen extends StatefulWidget {
  const KycUpdateScreen({super.key});

  @override
  State<KycUpdateScreen> createState() => _KycUpdateScreenState();
}

class _KycUpdateScreenState extends State<KycUpdateScreen> {
  final TextEditingController bvnController = TextEditingController();

  // final _sprintCheckPlugin = SprintCheck();
  // String _platformVersion = 'Unknown';

  // @override
  // void initState() {
  //   super.initState();
  //   initPlatformState();
  // }

  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   try {
  //     // platformVersion = await _sprintCheckPlugin.getPlatformVersion() ?? 'Unknown platform version';
      
  //     // _sprintCheckPlugin.initialize(
  //     //   api_key: "*******************************",
  //     //   encryption_key: "*******************************",
  //     // );
  //     _sprintCheckPlugin.initialize(
  //       api_key: "scb1edcd88-64f7485186d9781ca624a903",
  //       encryption_key: "enc67fe4978b16fc1744718200",
  //     );

  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        centerTitle: false,
        title: "KYC Update",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(30),
                TextSemiBold("BVN"),
                const Gap(8),
                TextFormField(
                  controller: bvnController,
                  validator: (value) {},
                  decoration: textInputDecoration.copyWith(
                    filled: false,
                    hintText: "",
                    hintStyle: const TextStyle(
                        color: AppColors.primaryGrey2
                    )
                  ),
                ),

                const Gap(30),
                TouchableOpacity(
                  onTap: () async {
                    // var response = await _sprintCheckPlugin.checkout(
                    //     context,
                    //     CheckoutMethod.bvn,
                    //     bvnController.text.trim(),
                    //   );
                    //   print("response for the sdk: $response");
                  },
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          color: AppColors.white.withOpacity(0.3),
                        ),
                        const Gap(5),
                        TextSemiBold(
                          "Submit",
                          color: AppColors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ]
            )
          )
        )
      )
    );
  }
}
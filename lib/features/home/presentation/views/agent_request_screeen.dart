import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/navigators/routes_name.dart';

class AgentRequestScreen extends StatefulWidget {
  const AgentRequestScreen({super.key});

  @override
  State<AgentRequestScreen> createState() => _AgentRequestScreenState();
}

class _AgentRequestScreenState extends State<AgentRequestScreen> {
  Widget rowcard(String name, String details, bool isActive) {
    return TouchableOpacity(
      onTap: () => context.goNamed(Routes.agentProfileInfo),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryGrey, width: 0.5),
              color: AppColors.white,
              borderRadius: BorderRadius.circular(3)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSemiBold(name),
                      const Gap(7),
                      TextSemiBold(details),
                    ],
                  ),
                ),
                const Spacer(),
                SvgPicture.asset(
                  AppAsset.check,
                  color: isActive == false ? AppColors.inactiveColor : null,
                ),
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
        title: "Agent Request",
        // elevation: 2,
      ),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const Gap(20),
              rowcard('Step 1', 'Provide personal details', true),
              rowcard('Step 2',
                  "Provide copy of signed document sent to your email", false),
              rowcard('Step 3',
                  "Awaiting verification", false)

            ],
          ),
        ),
      )),
    );
  }
}

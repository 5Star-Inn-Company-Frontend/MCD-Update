import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/plans_module/plans_module_controller.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class PlansModulePage extends GetView<PlansModuleController> {
  const PlansModulePage({super.key, this.isAppbar = true});

  final bool? isAppbar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isAppbar == true
          ? const PaylonyAppBarTwo(
              title: "Plan",
              centerTitle: false,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
        child: CustomSingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  TextBold(
                    "BRONZE",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  const Gap(20),
                  TextSemiBold(
                    "For small and medium businesses",
                    fontSize: 13,
                  ),
                  const Gap(20),
                  const Text(
                    "₦15,000",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Gap(40),
              Column(
                children: controller.planFeatures
                    .map((feature) => _planCard(feature))
                    .toList(),
              ),
              const Spacer(),
              BusyButton(
                  width: screenWidth(context) * 0.6,
                  title: "Upgrade",
                  onTap: controller.upgradePlan)
            ],
          ),
        ),
      ),
    );
  }

  Widget _planCard(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SvgPicture.asset(AppAsset.greenTick),
          const Gap(8),
          TextSemiBold(
            title,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    );
  }
}
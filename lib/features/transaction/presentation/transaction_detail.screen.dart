import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/constants.dart';
import 'package:mcd/core/utils/functions.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String image;
  final String name;
  final double amount;
  const TransactionDetailScreen(
      {super.key,
      required this.amount,
      required this.name,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: "Transaction Detail",
        centerTitle: false,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
            width: double.infinity,
            // height: 400,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAsset.spiralBg), fit: BoxFit.fill)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Material(
                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: const Color(0xff000000).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage(image),
                          width: 50,
                          height: 50,
                        ),
                        const Gap(8),
                        TextSemiBold(
                          name,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        const Gap(6),
                        TextSemiBold(
                          Functions.money(amount, "N"),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_outlined,
                              color: AppColors.primaryColor,
                            ),
                            const Gap(4),
                            TextSemiBold(
                              "Sucessful",
                              color: AppColors.primaryColor,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                Material(
                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: const Color(0xff000000).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        itemRow("User ID", "012345678"),
                        itemRow("Payment Type", "Betting Bills"),
                        itemRow("Payment Method", "MCD balance"),
                      ],
                    ),
                  ),
                ),
                const Gap(8),
                Material(
                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: const Color(0xff000000).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        itemRow("Transaction ID:", "012345678912345678"),
                        itemRow("Posted date:", "22:57, Jan 21, 2024"),
                        itemRow("Transaction date:", "22:58, Jan 21, 2024"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
            child: BusyButton(title: "Share Receipt", onTap: () {}),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                actionButtons(
                    () {}, SvgPicture.asset(AppAsset.downloadIcon), "Download"),
                actionButtons(
                    () {}, SvgPicture.asset(AppAsset.redoIcon), "Buy Again"),
                actionButtons(() {}, SvgPicture.asset(AppAsset.rotateIcon),
                    "Add to recurring"),
                actionButtons(
                    () {}, SvgPicture.asset(AppAsset.helpIcon), "Support"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget itemRow(String name, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold(
            name,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          TextSemiBold(
            value,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          )
        ],
      ),
    );
  }

  Widget actionButtons(VoidCallback onTap, Widget item, String name) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor),
              borderRadius: BorderRadius.circular(5)),
          child: item,
        ),
        const Gap(5),
        TextSemiBold(
          name,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        )
      ],
    );
  }
}

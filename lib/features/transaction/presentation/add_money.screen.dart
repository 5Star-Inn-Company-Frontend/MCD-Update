import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/transaction/presentation/card_top_up.screen.dart';
import 'package:mcd/features/transaction/presentation/ussd_transaction.screen.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
          title: "Fund Wallet", centerTitle: false, elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextSemiBold("Choose a method to receive money into your wallet"),
              const Gap(20),
              TextSemiBold(
                "Bank Transfer",
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              const Gap(20),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                decoration: BoxDecoration(
                    color: const Color(0xffF3FFF7),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextSemiBold(
                          "Akanji Joseph",
                          fontSize: 15,
                        ),
                        Row(
                          children: [
                            TextSemiBold("Share"),
                            const Gap(2),
                            SvgPicture.asset(AppAsset.share)
                          ],
                        )
                      ],
                    ),
                    const Gap(30),
                    TextSemiBold("Wema Bank"),
                    const Gap(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextSemiBold(
                          "123456789",
                          fontSize: 20,
                        ),
                        Row(
                          children: [
                            TextSemiBold(
                              "Copy",
                              color: AppColors.primaryColor,
                            ),
                            const Gap(5),
                            const Icon(
                              Icons.copy,
                              color: AppColors.primaryColor,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                decoration: BoxDecoration(
                    color: const Color(0xffF3FFF7),
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextSemiBold(
                          "Akanji Joseph",
                          fontSize: 15,
                        ),
                        Row(
                          children: [
                            TextSemiBold("Share"),
                            const Gap(2),
                            SvgPicture.asset(AppAsset.share)
                          ],
                        )
                      ],
                    ),
                    const Gap(30),
                    TextSemiBold("Wema Bank"),
                    const Gap(30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextSemiBold(
                          "123456789",
                          fontSize: 20,
                        ),
                        Row(
                          children: [
                            TextSemiBold(
                              "Copy",
                              color: AppColors.primaryColor,
                            ),
                            const Gap(5),
                            const Icon(
                              Icons.copy,
                              color: AppColors.primaryColor,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xffF0F0F0),
                    width: 1, // Border width
                  ),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const CardTopUpTransactionScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(AppAsset.card),
                              const Gap(8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextSemiBold('Top-up with Card'),
                                  const Gap(5),
                                  TextSemiBold(
                                      "Add money directly from your bank card")
                                ],
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                    const Gap(10),
                    const Divider(color: Color(0xffF0F0F0)),
                    const Gap(10),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const UssdTransactionScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(AppAsset.ussd),
                              const Gap(8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextSemiBold('USSD'),
                                  const Gap(5),
                                  SizedBox(
                                    width: screenWidth(context) * 0.7,
                                    child: TextSemiBold(
                                        "Add money to your wallet using ussd on your phone"),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/utils/functions.dart';

class ElectricityTransactionScreen extends StatelessWidget {
    final String image;
  final String name;
  final double amount;
  const ElectricityTransactionScreen({super.key, required this.amount, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: const PaylonyAppBarTwo(
        title: "Transaction Detail",
        centerTitle: false,
      ),
       body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(vertical:25, horizontal: 12),
            width: double.infinity,
            // height: 400,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage(AppAsset.spiralBg), fit: BoxFit.fill)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        const Image(image: AssetImage('assets/images/ie.png'), width: 50,height: 50,),
                        const Gap(8),
                        TextSemiBold(name, fontSize: 22, fontWeight: FontWeight.w600,),
                        const Gap(6),
                        TextSemiBold(Functions.money(amount, "N"), fontSize: 22, fontWeight: FontWeight.w600,),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline_outlined, color: AppColors.primaryColor,),
                            const Gap(4),
                            TextSemiBold("Sucessful", color: AppColors.primaryColor,)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Gap(10),
                TextSemiBold("Token"),
                const Gap(4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xffF3FFF7),
                    border: Border.all(
                      color: AppColors.primaryColor,
                    ),

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("01234567890987654321", style: TextStyle
                        (
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        // fontFamily: AppFonts.manRope
                      ),),
                      // TextSemiBold("Select Amount"),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: TextSemiBold("Copy", color: AppColors.white,),
                      )
                    ],
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
            child: BusyButton(title: "Share Receipt", onTap:(){

            }),
          ),
         
        ],
      ),
    );
  }

   Widget itemRow(String name, String value){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold(name, fontSize: 15, fontWeight: FontWeight.w500,),
          TextSemiBold(value, fontSize: 15, fontWeight: FontWeight.w500,)
        ],
      ),
    );
  }
}
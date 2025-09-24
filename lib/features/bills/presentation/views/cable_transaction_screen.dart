import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/utils/functions.dart';

class CableTransactionScreen extends StatelessWidget {
     final String image;
  final String name;
  final double amount;
  const CableTransactionScreen({super.key,  required this.amount, required this.name, required this.image});

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
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(vertical:25, horizontal: 12),
            width: double.infinity,
            // height: 400,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(AppAsset.spiralBg), fit: BoxFit.fill)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Material(
                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: Color(0xff000000).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        Image(image: AssetImage('assets/images/gotv.png'), width: 50,height: 50,),
                        Gap(8),
                        TextSemiBold(name, fontSize: 22, fontWeight: FontWeight.w600,),
                        Gap(6),
                        TextSemiBold(Functions.money(amount, "N"), fontSize: 22, fontWeight: FontWeight.w600,),
                        Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline_outlined, color: AppColors.primaryColor,),
                            Gap(4),
                            TextSemiBold("Sucessful", color: AppColors.primaryColor,)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
               
                Gap(8),
                Material(

                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: Color(0xff000000).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        itemRow("User ID", "012345678"),
                        itemRow("Biller Name", "GOtv"),
                        itemRow("Payment Type", "Cable Tv"),
                        itemRow("Payment Method", "MCD balance"),
                      ],
                    ),
                  ),
                ),
                Gap(8),
                Material(

                  elevation: 2,
                  color: AppColors.white,
                  shadowColor: Color(0xff000000).withOpacity(0.3),
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
      margin: EdgeInsets.symmetric(vertical: 10),
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
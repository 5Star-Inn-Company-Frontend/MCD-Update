import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/constants.dart';

class GiveawayScreen extends StatelessWidget {
  const GiveawayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Giveaway",
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              child: TextSemiBold("History", fontWeight: FontWeight.w700, fontSize: 18,),
            ),
          )

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.background,
                ),

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextSemiBold("You have 0 giveaways"),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: TextSemiBold("Create giveaway", color: AppColors.white,),
                  )
                ],
              ),
            ),
            const Gap(30),
            TextSemiBold("All Giveaways"),
            const Gap(19),

            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 26.0,
                  mainAxisSpacing: 16.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return AspectRatio(
                      aspectRatio: 3 / 2,
                      child: _boxCard( "Samuel 0", '5,000 claims', (){

                      }));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxCard(String title, String text, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
          color: const Color(0xffF3FFF7),
          border: Border.all(color: const Color(0xffF0F0F0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextSemiBold(
            title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),

          Text(
            text,
            style: const TextStyle(
              fontFamily: AppFonts.manRope,
              fontWeight: FontWeight.w500,
              fontSize: 15
            ),
            textAlign: TextAlign.center,
          ),
          BusyButton(title: "Claim", height: 40, onTap: onTap)
        ],
      ),
    );
  }

}

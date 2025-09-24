import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class CableMonthPlanWidget extends StatefulWidget {
  const CableMonthPlanWidget({super.key});

  @override
  State<CableMonthPlanWidget> createState() => _CableMonthPlanWidgetState();
}

class _CableMonthPlanWidgetState extends State<CableMonthPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
  slivers: [
    SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
       crossAxisCount: 2,
        childAspectRatio: 4 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          switch (index) {
            case 0:
              return Container(
                height: 22,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                    color: AppColors.primaryColor
                  )
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                     Row(
                       children: [
                         TextSemiBold("Jolli/", fontWeight: FontWeight.w600,fontSize: 14,),
                          TextSemiBold("month", fontWeight: FontWeight.w500,fontSize: 12,),
                       ],
                     ),
                     TextSemiBold("₦3950", fontWeight: FontWeight.w500,fontSize: 12,),
                     TextSemiBold("#3 cash back", fontWeight: FontWeight.w500,fontSize: 11,),
              ],),
              );
            case 1:
              return Container(
                     height: 22,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                    color: AppColors.primaryColor
                  )
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                     Row(
                       children: [
                         TextSemiBold("Family/", fontWeight: FontWeight.w600,fontSize: 14,),
                          TextSemiBold("month", fontWeight: FontWeight.w500,fontSize: 12,),
                       ],
                     ),
                     TextSemiBold("₦3950", fontWeight: FontWeight.w500,fontSize: 12,),
                     TextSemiBold("#3 cash back", fontWeight: FontWeight.w500,fontSize: 11,),
              ],),
              );
            case 2:
              return Container(
             height: 22,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                    color: AppColors.primaryColor
                  )
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                     Row(
                       children: [
                         TextSemiBold("Max/", fontWeight: FontWeight.w600,fontSize: 14,),
                          TextSemiBold("month", fontWeight: FontWeight.w500,fontSize: 12,),
                       ],
                     ),
                     TextSemiBold("₦5950", fontWeight: FontWeight.w500,fontSize: 12,),
                     TextSemiBold("#3 cash back", fontWeight: FontWeight.w500,fontSize: 11,),
              ],),
              );
            // Add more cases for additional items
            default:
              return Container();
          }
        },
        childCount: 3, // Update this to the desired number of items
      ),
    ),
  ],
);
  }
}
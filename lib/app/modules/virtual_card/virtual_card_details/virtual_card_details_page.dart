import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './virtual_card_details_controller.dart';

class VirtualCardDetailsPage extends GetView<VirtualCardDetailsController> {
  const VirtualCardDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
            Gap(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/card.svg',
                  width: screenWidth(context) * 0.75,
                ),
              ],
            ),
            Gap(30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name',
                      style: GoogleFonts.quicksand(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(189, 189, 189, 1)),
                    ),
                    Gap(10.h),
                    Text(
                      'Card Number',
                      style: GoogleFonts.quicksand(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(189, 189, 189, 1)),
                    ),
                    Gap(10.h),
                    Text(
                      'CVV',
                      style: GoogleFonts.quicksand(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(189, 189, 189, 1)),
                    ),
                    Gap(10.h),
                    Text(
                      'Expiry Date',
                      style: GoogleFonts.quicksand(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(189, 189, 189, 1)),
                    ),
                    Gap(10.h),
                    Text(
                      'Currency',
                      style: GoogleFonts.quicksand(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(189, 189, 189, 1)),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Oluwa wa',
                      style: GoogleFonts.quicksand(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    Gap(10.h),
                    Row(
                      children: [
                        Text(
                          '2138 2138 2138 2138',
                          style: GoogleFonts.quicksand(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 1)),
                        ),
                        Gap(13.w),
                        Icon(
                          Icons.copy,
                          color: const Color.fromRGBO(90, 187, 123, 1),
                          size: 12.5.sp,
                        ),
                      ],
                    ),
                    Gap(10.h),
                    Text(
                      '381',
                      style: GoogleFonts.quicksand(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    Gap(10.h),
                    Text(
                      '12 Dec 2024',
                      style: GoogleFonts.quicksand(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(0, 0, 0, 1)),
                    ),
                    Gap(10.h),
                    Text(
                      'Dollar',
                      style: GoogleFonts.quicksand(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(0, 0, 0, 1)),
                    ),
                  ],
                ),
              ],
            ),
            Gap(30.h),
            TextButton(
              onPressed: () {},
              child: Text(
                'Delete Card',
                style: GoogleFonts.rubik(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(51, 160, 88, 1)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

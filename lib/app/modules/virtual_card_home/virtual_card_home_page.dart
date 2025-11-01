import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/modules/virtual_card_request/widgets/card_button.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './virtual_card_home_controller.dart';

class VirtualCardHomePage extends GetView<VirtualCardHomeController> {
  const VirtualCardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool cardIsAdded = Get.arguments?['cardIsAdded'] ?? false;

    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Virtual Card",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cardIsAdded == false ? 'Add Card' : 'My Card',
                  style: GoogleFonts.rubik(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(19, 1, 56, 1)),
                ),
              ],
            ),
            Gap(30.h),
            SvgPicture.asset(
              'assets/images/card.svg',
              width: screenWidth(context) * 0.75,
            ),
            cardIsAdded == false
                ? Column(
                    children: [
                      Gap(40.h),
                      Text(
                        'Add a new card\non your wallet for easy life',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(0, 0, 0, 1)),
                      ),
                      Gap(50.h),
                      CardButton(
                          onTap: () {
                            Get.toNamed(Routes.VIRTUAL_CARD_REQUEST);
                          },
                          text: 'Request')
                    ],
                  )
                : Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.VIRTUAL_CARD_DETAILS);
                        },
                        child: Container(
                          height: screenHeight(context) * 0.035,
                          width: screenWidth(context) * 0.35,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(90, 180, 123, 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'My Card Detail',
                                  style: GoogleFonts.manrope(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                const Icon(
                                  Icons.subdirectory_arrow_right_sharp,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
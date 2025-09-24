import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/virtual_card/presentation/views/virt_card_home_screen.dart';
import 'package:mcd/features/virtual_card/presentation/widgets/card_button.dart';

class VirtCardAppScreen extends StatefulWidget {
  final String name;
  final String email;
  final String number;
  final String dob;
  final String insuranceFee;
  final String maintenanceFee;
  const VirtCardAppScreen({super.key, required this.name, required this.email, required this.number, required this.dob, required this.insuranceFee, required this.maintenanceFee});

  @override
  State<VirtCardAppScreen> createState() => _VirtCardAppScreenState();
}

class _VirtCardAppScreenState extends State<VirtCardAppScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Card Application",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: screenHeight(context) * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(20.h),

                  Text('Confirm your details before you proceed', style: GoogleFonts.roboto(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1)),),

                  Gap(20.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Name', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(0, 0, 0, 1)),),
                      Text(widget.name, style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1)),),
                    ],
                  ),

                  Gap(15.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Email address', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(0, 0, 0, 1)),),
                      Text(widget.email, style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1)),),
                    ],
                  ),

                  Gap(15.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phone Number', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(0, 0, 0, 1)),),
                      Text(widget.number, style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1)),),
                    ],
                  ),

                  Gap(15.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date of birth', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(0, 0, 0, 1)),),
                      Text(widget.dob, style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1)),),
                    ],
                  ),

                  Gap(50.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Fee and Charges', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w700, color: const Color.fromRGBO(0, 0, 0, 1)),),
                    ],
                  ),

                  Gap(15.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Insurance Fee', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(0, 0, 0, 1)),),
                      Text(widget.insuranceFee, style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1)),),
                    ],
                  ),

                  Gap(15.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Maintenance Fee', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(0, 0, 0, 1)),),
                      Text(widget.maintenanceFee, style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(0, 0, 0, 1)),),
                    ],
                  ),
                ]
              )
            ),


            CardButton(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const VirtCardHomeScreen(cardIsAdded: true,)));
              },
              text: 'Proceed'
            )
          ]
        )
      )
    );
  }
}
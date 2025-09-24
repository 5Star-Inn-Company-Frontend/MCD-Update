import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/single_child_scroll_view.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/seller_screen.dart';
import 'package:mcd/features/shop/presentation/views/seller_screens/upload_market_screen.dart';

class ConfirmOrEditUploadMarketScreen extends StatefulWidget {
  final String productNameController;
  final String productDetailsController;
  final String keyFeaturesController;
  final String whatIsTheBoxController;
  final String productspecificationsController;

  const ConfirmOrEditUploadMarketScreen({super.key, required this.productNameController, 
    required this.productDetailsController, 
    required this.keyFeaturesController, 
    required this.whatIsTheBoxController, 
    required this.productspecificationsController});

  @override
  State<ConfirmOrEditUploadMarketScreen> createState() => _ConfirmOrEditUploadMarketScreenState();
}

class _ConfirmOrEditUploadMarketScreenState extends State<ConfirmOrEditUploadMarketScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: 'Upload your Market', centerTitle: false,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(30.h),
          
              Text('Product Picture', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(20.h),
          
              Text('Product Name', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(7.h),
          
              Text(widget.productNameController, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(20.h),
          
              Text('Variation Available', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(7.h),
          
              Text('Colour', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(20.h),
          
              Text('Quantity in Total', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(7.h),
          
              Text('30', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(20.h),
          
              Text('Product Price', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(7.h),
          
              Text('#33,000', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(20.h),
          
              Text('Discount Price', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(7.h),
          
              Text('0%', style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(20.h),
          
              Text('Product Details', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(7.h),
          
              Text(
                widget.productDetailsController,
                style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),
              ),
          
              Gap(20.h),
          
              Text('Key Features', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(7.h),
          
              Text(widget.keyFeaturesController, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(20.h),
          
              Text('What is the Box', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(7.h),
          
              Text(widget.whatIsTheBoxController, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(20.h),
          
              Text('Specifications', style: GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(135, 135, 135, 1)),),
          
              Gap(7.h),
          
              Text(widget.productspecificationsController, style: GoogleFonts.poppins(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(0, 0, 0, 1)),),
          
              Gap(30.h),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UploadMarketScreen()));
                    },
                    child: Container(
                      height: 30.h,
                      width: 160.w,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(235, 0, 27, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text(
                        'EDIT',
                        style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
                    ),
                  ),),
          
                  InkWell(
                    onTap: () {
                      _showConfirmDialog();
          
                      Timer(const Duration(seconds: 6), () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const SellerScreen()),
                        );
                      });
                    },
                    child: Container(
                      height: 30.h,
                      width: 160.w,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(90, 187, 123, 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text(
                        'CONFIRM',
                        style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
                    ),
                  ),)
                ],
              )
          
            ]
          )
        )
      )
    );
  }

  _showConfirmDialog() {
    return Scaffold(
      backgroundColor: Colors.transparent.withOpacity(0.3),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 16),
            height: screenWidth(context) * 0.7,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Confirm Successful', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 24.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(73, 73, 75, 1))),

                Gap(30.h),

                Text('Your product has been submitted for review', textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(133, 133, 134, 1))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
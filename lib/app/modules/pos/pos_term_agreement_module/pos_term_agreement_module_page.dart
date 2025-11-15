import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './pos_term_agreement_module_controller.dart';

class PosTermAgreementModulePage extends GetView<PosTermAgreementModuleController> {
  const PosTermAgreementModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Agreement",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(20.h),
            Text('Follow this process to complete your process.', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
            Gap(15.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Download and review the Document.', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                Gap(5.h),
                Text('2. Append your signature where necessary.', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                Gap(5.h),
                Text('3. Submit the signed document.', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
              ],
            ),
            Gap(30.h),
            Container(
              width: double.infinity,
              height: screenHeight(context) * 0.2,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/document.svg'),
                  Gap(10.w),
                  Text('Agent Agreement Doc.', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
                ],
              ),
            ),
            Gap(130.h),
            InkWell(
              onTap: () {},
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Download Agreement', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
                    Gap(10.w),
                    const Icon(Icons.file_open_outlined, color: Colors.white,),
                  ],
                ),
            ),),
            Gap(20.h),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.POS_TERM_SUBMIT_DOC);
              },
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color.fromRGBO(51, 160, 88, 1)),
                ),
                child: Center(child: Text('Submit here', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 160, 88, 1)),)),
            ),),
          ]
        )
      )
    );
  }
}

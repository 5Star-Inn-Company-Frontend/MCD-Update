import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import './pos_request_new_term_module_controller.dart';

class PosRequestNewTermModulePage extends GetView<PosRequestNewTermModuleController> {
  const PosRequestNewTermModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Select Terminal Type",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: controller.terminals.map((terminal) {
            return InkWell(
              onTap: () => controller.selectTerminal(terminal['name']!),
              child: _terminalTypeContainer(
                terminal['image']!,
                terminal['name']!,
                terminal['outrightPurchase']!,
                terminal['lease']!,
                terminal['installment']!,
                terminal['installmentInitial']!,
                terminal['repayment']!,
                terminal['frequency']!,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _terminalTypeContainer(
    String imageName,
    String terminalName,
    String outrightPurchase,
    String lease,
    String installment,
    String installmentInitial,
    String repayment,
    String frequency,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Image.asset(imageName),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  terminalName,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromRGBO(51, 51, 51, 1),
                  ),
                ),
                Gap(7.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Outright Purchase',
                          style: GoogleFonts.manrope(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                        Text(
                          'N$outrightPurchase',
                          style: GoogleFonts.manrope(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                      ],
                    ),
                    Gap(8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lease',
                          style: GoogleFonts.manrope(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                        Text(
                          'N$lease',
                          style: GoogleFonts.manrope(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Installment',
                          style: GoogleFonts.manrope(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                        Text(
                          'N$installment',
                          style: GoogleFonts.manrope(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                      ],
                    ),
                    Gap(8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Installment initial amount',
                            style: GoogleFonts.manrope(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(112, 112, 112, 1),
                            ),
                          ),
                          Text(
                            'N$installmentInitial',
                            style: GoogleFonts.manrope(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(112, 112, 112, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(5.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Repayment',
                          style: GoogleFonts.manrope(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                        Text(
                          'N$repayment',
                          style: GoogleFonts.manrope(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                      ],
                    ),
                    Gap(8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Frequency',
                          style: GoogleFonts.manrope(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                        Text(
                          frequency,
                          style: GoogleFonts.manrope(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(112, 112, 112, 1),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

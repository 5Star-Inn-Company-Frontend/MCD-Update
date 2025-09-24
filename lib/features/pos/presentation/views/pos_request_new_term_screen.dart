import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/features/pos/presentation/views/pos_term_req_form_screen.dart';

class PosRequestNewTermScreen extends StatefulWidget {
  const PosRequestNewTermScreen({super.key});

  @override
  State<PosRequestNewTermScreen> createState() => _PosRequestNewTermScreenState();
}

class _PosRequestNewTermScreenState extends State<PosRequestNewTermScreen> {
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
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosTermReqFormScreen()));
              },
              child: terminalTypeContainer('assets/images/k11-terminal.png', 'K11 Terminal')),
            terminalTypeContainer('assets/images/mp35p-terminal.png', 'MP35P Terminal'),
        ]
      )
    ));
  }

  Widget terminalTypeContainer(String imageName, String terminalName) {
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(terminalName, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w600, color: const Color.fromRGBO(51, 51, 51, 1)),),
              
              Gap(7.h),

              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Outright Purchase', style: GoogleFonts.manrope(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('N130,000', style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                    ],
                  ),

                  Gap(8.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lease', style: GoogleFonts.manrope(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('N0', style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
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
                      Text('Installment', style: GoogleFonts.manrope(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('N140,000', style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                    ],
                  ),

                  Gap(8.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Installment initial amount', style: GoogleFonts.manrope(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('N60,000', style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                    ],
                  ),
                ],
              ),

              Gap(5.h),

              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Repayment', style: GoogleFonts.manrope(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('N1,000', style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                    ],
                  ),

                  Gap(8.w),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Frequency', style: GoogleFonts.manrope(fontSize: 8.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('Per day', style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                    ],
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
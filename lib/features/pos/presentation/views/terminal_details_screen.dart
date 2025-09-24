import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/pos/presentation/views/pos_terminal_settings_screen.dart';
import 'package:mcd/features/pos/presentation/views/pos_terminal_transaction_history_screen.dart';
import 'package:mcd/features/pos/presentation/views/pos_withdrawal_screen.dart';

class TerminalDetailsScreen extends StatefulWidget {
  const TerminalDetailsScreen({super.key});

  @override
  State<TerminalDetailsScreen> createState() => _TerminalDetailsScreenState();
}

class _TerminalDetailsScreenState extends State<TerminalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "203345678294-",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
            Container(
              // height: screenHeight(context) * 0.2,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Available Balance', style: GoogleFonts.roboto(fontSize: 11.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  const Gap(5),
                  Text('₦ 8,987,374', style: GoogleFonts.manrope(fontSize: 24.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  const Gap(5),
                  Text('Cashback Balance: ₦500', style: GoogleFonts.roboto(fontSize: 11.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  const Gap(10),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: screenHeight(context) * 0.035,
                        width: screenWidth(context) * 0.25,
                        // padding: EdgeInsets.only(),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(90, 187, 123, 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.add, color: Colors.white),
                            Text('Add Funds', style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.white),),
                          ],
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosWithdrawalScreen()));},
                      child: Container(
                        height: screenHeight(context) * 0.035,
                        width: screenWidth(context) * 0.25,
                        // padding: EdgeInsets.only(),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color.fromRGBO(90, 187, 123, 1), width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.add, color: Color.fromRGBO(90, 187, 123, 1)),
                            Text('Withdrawal', style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(90, 187, 123, 1)),),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                ]
              )
            ),

            const Gap(15),

            Container(
              // height: screenHeight(context) * 0.2,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 24, bottom: 24),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(90, 187, 123, 0.04),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Current Level', style: GoogleFonts.roboto(fontSize: 11.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  const Gap(5),
                  Text('Star 2', style: GoogleFonts.roboto(fontSize: 24.sp, fontWeight: FontWeight.w700, color: const Color.fromRGBO(90, 187, 123, 1)),),

                  const Gap(5),
                  Text('Cashback Balance: ₦500', style: GoogleFonts.roboto(fontSize: 11.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  const Gap(10),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: screenHeight(context) * 0.065,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(90, 187, 123, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: Text('See Star Levels', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),),
                    ),
                  ),
                ]
              )
            ),

            const Gap(15),
            Container(
              // height: screenHeight(context) * 0.2,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Terminal Details', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Business Name:', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('GiftBills', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),
                    ],
                  ),

                  const Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Terminal ID:', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('GiftBills', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),
                    ],
                  ),

                  const Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Terminal Type:', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('MP35P', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),
                    ],
                  ),

                  const Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Serial Number:', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      Text('3D903534', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),
                    ],
                  ),
                ]
              )
            ),
            
            const Gap(10),
            InkWell(onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosTerminalTransactionHistoryScreen()));
            }, child: containerWidget('assets/icons/trans-hist-icon.svg', 'Transaction Details')),
            const Gap(10),
            InkWell(onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosTerminalSettingsScreen()));
            }, child: containerWidget('assets/icons/setting.svg', 'Settings')),
            const Gap(10),
            InkWell(onTap: () {}, child: containerWidget('assets/icons/info-circle.svg', 'Daily Report')),
          ]
        )
      )
    );
  }


  Widget containerWidget(String icon, String title) {
    return Container(
      height: screenHeight(context) * 0.08,
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: screenHeight(context) * 0.05,
                width: screenWidth(context) * 0.1,
                child: CircleAvatar(
                  backgroundColor: const Color.fromRGBO(90, 187, 123, 0.2),
                  child: SvgPicture.asset(icon),
                ),
              ),
              const Gap(20),                    
              Text(title, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1))),
            ],
          ),
    
          IconButton(onPressed: () {}, icon: const Icon(Icons.keyboard_arrow_right_rounded, color: Color.fromRGBO(112, 112, 112, 1), size: 40)),
        ],
      )
    );
  }
}
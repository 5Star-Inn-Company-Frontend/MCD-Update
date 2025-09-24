import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/pos/presentation/views/pos_terminal_change_pin_screen.dart';

class PosTerminalSettingsScreen extends StatefulWidget {
  const PosTerminalSettingsScreen({super.key});

  @override
  State<PosTerminalSettingsScreen> createState() => _PosTerminalSettingsScreenState();
}

class _PosTerminalSettingsScreenState extends State<PosTerminalSettingsScreen> {
  bool _disableBankTransfer = false;
  bool _disableBillsPayment = false;
  bool _disableCardTransfer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Terminal Settings",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            const Gap(10),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosTerminalChangePinScreen()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Change terminal PIN', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
              
                    const Icon(Icons.keyboard_arrow_right, size: 30, color: Color.fromRGBO(51, 51, 51, 1),)
                  ],
                ),
              ),
            ),

            const Gap(10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Disable Bank Transfer', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  Switch(
                    activeColor: const Color.fromRGBO(62, 178, 91, 1),
                    activeTrackColor: const Color.fromRGBO(90, 187, 123, 0.2),
                    inactiveTrackColor: const Color.fromRGBO(211, 208, 217, 1),
                    inactiveThumbColor: Colors.white,
                    trackOutlineColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                    value: _disableBankTransfer,
                    onChanged: (bool value) {
                      setState(() {
                        _disableBankTransfer = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const Gap(10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Disable Bills Payment', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  Switch(
                    activeColor: const Color.fromRGBO(62, 178, 91, 1),
                    activeTrackColor: const Color.fromRGBO(90, 187, 123, 0.2),
                    inactiveTrackColor: const Color.fromRGBO(211, 208, 217, 1),
                    inactiveThumbColor: Colors.white,
                    trackOutlineColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                    value: _disableBillsPayment,
                    onChanged: (bool value) {
                      setState(() {
                        _disableBillsPayment = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const Gap(10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Disable Card Transfer', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  Switch(
                    activeColor: const Color.fromRGBO(62, 178, 91, 1),
                    activeTrackColor: const Color.fromRGBO(90, 187, 123, 0.2),
                    inactiveTrackColor: const Color.fromRGBO(211, 208, 217, 1),
                    inactiveThumbColor: Colors.white,
                    trackOutlineColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
                    value: _disableCardTransfer,
                    onChanged: (bool value) {
                      setState(() {
                        _disableCardTransfer = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const Gap(10),
            InkWell(
              onTap: () {},
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color.fromRGBO(51, 160, 88, 1), width: 1),
                ),
                child: Center(child: Text('Log Out POS', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 160, 88, 1),),),
              ),
            ),)
          ]
        )
      )
    );
  }
}
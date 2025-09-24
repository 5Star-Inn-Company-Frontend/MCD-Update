import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import 'package:mcd/features/pos/presentation/views/pos_term_otp_screen.dart';

class PosTerminalChangePinScreen extends StatefulWidget {
  const PosTerminalChangePinScreen({super.key});

  @override
  State<PosTerminalChangePinScreen> createState() => _PosTerminalChangePinScreenState();
}

class _PosTerminalChangePinScreenState extends State<PosTerminalChangePinScreen> {
  final TextEditingController _currentPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Change Terminal Pin",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            const Gap(20),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Current Pin', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
              ],
            ),
            const Gap(5),
            pinTextField(_currentPinController),

            const Gap(20),  
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Enter New Pin', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
              ],
            ),
            const Gap(5),
            pinTextField(_currentPinController),

            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Confirm New Pin', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
              ],
            ),
            const Gap(5),
            pinTextField(_currentPinController),

            const Gap(30),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PosTermOtpScreen()));
              },
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('Confirm', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
              ),
            ),)
          ]
        )
      )
    );
  }

  Widget pinTextField(TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      obscuringCharacter: '●',
      cursorColor: const Color.fromRGBO(90, 187, 123, 1),
      decoration: InputDecoration(
        hintText: 'Enter current pin',
        hintStyle: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(211, 208, 217, 1)),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
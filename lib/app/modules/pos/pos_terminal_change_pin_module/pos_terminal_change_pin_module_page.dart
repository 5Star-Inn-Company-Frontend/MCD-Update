import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './pos_terminal_change_pin_module_controller.dart';

class PosTerminalChangePinModulePage extends GetView<PosTerminalChangePinModuleController> {
  const PosTerminalChangePinModulePage({super.key});

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
            _pinTextField(controller.currentPinController, 'Enter current pin'),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Enter New Pin', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
              ],
            ),
            const Gap(5),
            _pinTextField(controller.newPinController, 'Enter new pin'),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Confirm New Pin', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
              ],
            ),
            const Gap(5),
            _pinTextField(controller.confirmPinController, 'Confirm new pin'),
            const Gap(30),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.POS_TERM_OTP);
              },
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('Confirm', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),)),
              ),
            ),
          ]
        )
      )
    );
  }

  Widget _pinTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      obscureText: true,
      obscuringCharacter: '●',
      cursorColor: const Color.fromRGBO(90, 187, 123, 1),
      style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(211, 208, 217, 1)),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

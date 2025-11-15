import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './pos_terminal_settings_module_controller.dart';

class PosTerminalSettingsModulePage extends GetView<PosTerminalSettingsModuleController> {
  const PosTerminalSettingsModulePage({super.key});

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
                Get.toNamed(Routes.POS_TERMINAL_CHANGE_PIN);
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
            Obx(() => Container(
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
                    value: controller.disableBankTransfer.value,
                    onChanged: (bool value) {
                      controller.disableBankTransfer.value = value;
                    },
                  ),
                ],
              ),
            )),
            const Gap(10),
            Obx(() => Container(
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
                    value: controller.disableBillsPayment.value,
                    onChanged: (bool value) {
                      controller.disableBillsPayment.value = value;
                    },
                  ),
                ],
              ),
            )),
            const Gap(10),
            Obx(() => Container(
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
                    value: controller.disableCardTransfer.value,
                    onChanged: (bool value) {
                      controller.disableCardTransfer.value = value;
                    },
                  ),
                ],
              ),
            )),
            const Gap(10),
            InkWell(
              onTap: () {
                controller.saveSettings();
              },
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('Save', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

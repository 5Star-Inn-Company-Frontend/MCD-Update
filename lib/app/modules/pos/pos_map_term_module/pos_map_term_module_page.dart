import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './pos_map_term_module_controller.dart';

class PosMapTermModulePage extends GetView<PosMapTermModuleController> {
  const PosMapTermModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Map New Terminal",
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
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Serial Number', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
              ],
            ),
            const Gap(5),
            TextField(
              controller: controller.serialNumberController,
              cursorColor: const Color.fromRGBO(90, 187, 123, 1),
              style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),
              decoration: InputDecoration(
                hintText: 'Enter serial number',
                hintStyle: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 0.3)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color.fromRGBO(90, 187, 123, .2), width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Gap(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Terminal Type', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
              ],
            ),
            const Gap(10),
            Obx(() => Container(
              height: screenHeight(context) * 0.05,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    borderRadius: BorderRadius.circular(8),
                    dropdownColor: Colors.white,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 40,),
                    value: controller.selectedTerminalType.value.isEmpty ? null : controller.selectedTerminalType.value,
                    onChanged: (String? newValue) {
                      controller.selectedTerminalType.value = newValue ?? '';
                    },
                    items: const [
                      DropdownMenuItem(value: 'K11 Terminal', child: Text('K11 Terminal')),
                      DropdownMenuItem(value: 'MP35P Terminal', child: Text('MP35P Terminal')),
                    ],
                  ),
                ),
              ),
            )),
            Gap(40.h),
            InkWell(
              onTap: () {
                controller.mapTerminal();
              },
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('Map Terminal', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
                ),
              ),
            ),
          ]
        )
      )
    );
  }
}

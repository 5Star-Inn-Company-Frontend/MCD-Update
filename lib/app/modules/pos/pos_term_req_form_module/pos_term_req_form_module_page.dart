import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/pos_dropdown.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './pos_term_req_form_module_controller.dart';

class PosTermReqFormModulePage extends GetView<PosTermReqFormModuleController> {
  const PosTermReqFormModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Request For Terminal",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
            Obx(() => PosDropdown(
              ddname: 'Terminal Type', 
              selectedValue: controller.terminalType.value.isEmpty ? null : controller.terminalType.value, 
              onChanged: (value) => controller.terminalType.value = value ?? '',
              listdd: const [
                DropdownMenuItem(value: 'K11 Terminal', child: Text('K11 Terminal')),
                DropdownMenuItem(value: 'MP35P Terminal', child: Text('MP35P Terminal')),
              ], 
            )),
            Gap(10.h),
            Obx(() => PosDropdown(
              ddname: 'Select Purchase Type', 
              selectedValue: controller.purchaseType.value.isEmpty ? null : controller.purchaseType.value,
              onChanged: (value) => controller.purchaseType.value = value ?? '',
              listdd: const [
                DropdownMenuItem(value: 'Outright Purchase', child: Text('Outright Purchase')),
                DropdownMenuItem(value: 'Lease Purchase', child: Text('Lease Purchase')),
              ],
            )),
            Gap(10.h),
            Obx(() => PosDropdown(
              ddname: 'Number of POS', 
              selectedValue: controller.numOfPos.value.isEmpty ? null : controller.numOfPos.value,
              onChanged: (value) => controller.numOfPos.value = value ?? '',
              listdd: const [
                DropdownMenuItem(value: '1', child: Text('1')),
                DropdownMenuItem(value: '2', child: Text('2')),
                DropdownMenuItem(value: '3', child: Text('3')),
              ],
            )),
            Gap(10.h),
            Obx(() => PosDropdown(
              ddname: 'Account Type', 
              selectedValue: controller.accountType.value.isEmpty ? null : controller.accountType.value,
              onChanged: (value) => controller.accountType.value = value ?? '',
              listdd: const [
                DropdownMenuItem(value: 'Agent', child: Text('Agent')),
                DropdownMenuItem(value: 'Savings', child: Text('Savings')),
                DropdownMenuItem(value: 'Current', child: Text('Current')),
              ],
            )),
            Gap(10.h),
            _textfieldWidget(context, controller.addressDeliveryController, 'Address For Delivery'),
            Gap(10.h),
            Obx(() => PosDropdown(
              ddname: 'Select State', 
              selectedValue: controller.selectState.value.isEmpty ? null : controller.selectState.value,
              onChanged: (value) => controller.selectState.value = value ?? '',
              listdd: const [
                DropdownMenuItem(value: 'Lagos', child: Text('Lagos')),
                DropdownMenuItem(value: 'Abuja', child: Text('Abuja')),
                DropdownMenuItem(value: 'Kano', child: Text('Kano')),
              ],
            )),
            Gap(10.h),
            Obx(() => PosDropdown(
              ddname: 'Select City', 
              selectedValue: controller.selectCity.value.isEmpty ? null : controller.selectCity.value,
              onChanged: (value) => controller.selectCity.value = value ?? '',
              listdd: const [
                DropdownMenuItem(value: 'Ikeja', child: Text('Ikeja')),
                DropdownMenuItem(value: 'Lekki', child: Text('Lekki')),
                DropdownMenuItem(value: 'Victoria Island', child: Text('Victoria Island')),
              ],
            )),
            Gap(10.h),
            _textfieldWidget(context, controller.contactNameController, 'Contact Name'),
            Gap(10.h),
            _textfieldWidget(context, controller.contactEmailController, 'Contact Email'),
            Gap(10.h),
            _textfieldWidget(context, controller.phoneNumberController, 'Phone Number'),
            Gap(9.h),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.POS_UPLOAD_LOCATION);
              },
              child: Container(
                height: screenHeight(context) * 0.065,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 160, 88, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('Proceed', style: GoogleFonts.manrope(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.white),),
              ),
            ),)
          ]
        )
      )
    );
  }

  Widget _textfieldWidget(BuildContext context, TextEditingController? controller, String tfieldname) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(tfieldname, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),),
          ],
        ),
        Gap(5.h),
        TextField(
          controller: controller,
          style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(51, 51, 51, 1)),
          cursorColor: const Color.fromRGBO(112, 112, 112, 1),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color.fromRGBO(112, 112, 112, 1))
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color.fromRGBO(120, 120, 120, 1))
            ),
          ),
        ),
      ],
    );
  }
}

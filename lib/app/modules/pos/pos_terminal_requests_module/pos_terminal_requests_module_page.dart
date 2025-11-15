import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import './pos_terminal_requests_module_controller.dart';

class PosTerminalRequestsModulePage extends GetView<PosTerminalRequestsModuleController> {
  const PosTerminalRequestsModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Terminal Requests",
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
            Obx(() => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.terminalRequests.length,
              itemBuilder: (context, index) {
                final request = controller.terminalRequests[index];
                return _requestTile(
                  request['terminal_type'] ?? '', 
                  request['date'] ?? '', 
                  request['time'] ?? '', 
                  request['purchaseType'] ?? '', 
                  request['amount'] ?? ''
                );
              }
            ))
          ]
        )
      )
    );
  }

  Widget _requestTile(String terminalType, String date, String time, String purchaseType, String amount) {
    return InkWell(
      onTap: () {
        // Navigate to detail screen
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(terminalType, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
                Text('Request Date: $date $time', style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),)
              ]
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(purchaseType, style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                Text(amount, style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),)
              ]
            )
          ],
        ),
      ),
    );
  }
}

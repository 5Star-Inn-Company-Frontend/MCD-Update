import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/pos/pos_terminal_requests_module/models/pos_request_model.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import './pos_terminal_requests_module_controller.dart';

import 'package:mcd/app/modules/pos/pos_terminal_requests_module/pos_request_details_page.dart';

class PosTerminalRequestsModulePage
    extends GetView<PosTerminalRequestsModuleController> {
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
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(51, 160, 88, 1),
            ),
          );
        }

        // Error state
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.withOpacity(0.5),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.errorMessage.value,
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      color: const Color.fromRGBO(112, 112, 112, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(24),
                ElevatedButton(
                  onPressed: controller.retryFetch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(51, 160, 88, 1),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Empty state
        if (controller.terminalRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: const Color.fromRGBO(112, 112, 112, 0.5),
                ),
                const Gap(16),
                Text(
                  'No terminal requests yet',
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(112, 112, 112, 1),
                  ),
                ),
                const Gap(8),
                Text(
                  'Your POS terminal requests will appear here',
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    color: const Color.fromRGBO(112, 112, 112, 0.7),
                  ),
                ),
              ],
            ),
          );
        }

        // Success state with data
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              const Gap(10), // Reduced top gap
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.terminalRequests.length,
                itemBuilder: (context, index) {
                  final request = controller.terminalRequests[index];
                  return _requestTile(request);
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _requestTile(PosRequestModel request) {
    return InkWell(
      onTap: () {
        Get.to(() => PosRequestDetailsPage(request: request));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16), // Increased padding
        margin: const EdgeInsets.only(bottom: 15), // Detailed spacing
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // More rounded
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Name and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MP35P Terminal', // Placeholder name as per design, logic can be dynamic later
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(51, 51, 51, 1),
                        ),
                      ),
                      const Gap(8),
                      Text(
                        'Request Date: ${request.formattedDate} ${request.formattedTime}',
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(153, 153, 153, 1),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Column: Type and Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      request.formattedPurchaseType,
                      style: GoogleFonts.manrope(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(112, 112, 112, 1),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      request.formattedAmount,
                      style: GoogleFonts.arimo(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromRGBO(51, 51, 51, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/pos/pos_terminal_requests_module/models/pos_request_model.dart';
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
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
              const Gap(20),
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
        // Navigate to detail screen
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: request.status == 0 
              ? Colors.orange.withOpacity(0.3)
              : request.status == 1
                ? Colors.green.withOpacity(0.3)
                : Colors.red.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reference: ${request.reference}',
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(51, 51, 51, 1),
                        ),
                      ),
                      const Gap(4),
                      Text(
                        'Request Date: ${request.formattedDate} ${request.formattedTime}',
                        style: GoogleFonts.manrope(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(112, 112, 112, 1),
                        ),
                      ),
                      const Gap(4),
                      Row(
                        children: [
                          Text(
                            'Qty: ${request.quantity}',
                            style: GoogleFonts.manrope(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(112, 112, 112, 1),
                            ),
                          ),
                          const Gap(12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: request.paymentStatus == 1
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              request.paymentStatusText,
                              style: GoogleFonts.manrope(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                                color: request.paymentStatus == 1
                                  ? Colors.green
                                  : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    const Gap(4),
                    Text(
                      request.formattedAmount,
                      style: GoogleFonts.manrope(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(51, 51, 51, 1),
                      ),
                    ),
                    const Gap(4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: request.status == 0
                          ? Colors.orange.withOpacity(0.1)
                          : request.status == 1
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        request.statusText,
                        style: GoogleFonts.manrope(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: request.status == 0
                            ? Colors.orange
                            : request.status == 1
                              ? Colors.green
                              : Colors.red,
                        ),
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

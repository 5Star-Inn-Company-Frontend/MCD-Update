import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/amount_formatter.dart';
import './virtual_card_top_up_controller.dart';

class VirtualCardTopUpPage extends GetView<VirtualCardTopUpController> {
  const VirtualCardTopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Top Up",
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 1),
            
            // Amount Display
            Obx(() => TextBold(
              "${controller.displayCurrency}${controller.formattedEnteredAmount}",
              fontSize: 48,
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w700,
            )),
            
            const Spacer(flex: 1),
            
            // Currency Exchange Bar
            Obx(() => Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: controller.isFetchingRate.value
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.isDollar.value ? "\$1" : "₦${AmountUtil.formatFigure(controller.exchangeRate.value)}",
                              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryColor)
                            ),
                            InkWell(
                              onTap: controller.toggleCurrency,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.swap_horiz,
                                  color: AppColors.primaryColor,
                                  size: 28,
                                ),
                              ),
                            ),
                            Text(
                              controller.rightSideDisplay,
                              style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryColor)
                            ),
                          ],
                        ),
                      ],
                    ),
            )),
            
            const Spacer(flex: 2),
            
            // Custom Keypad
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  childAspectRatio: 1.3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 30,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildKey("1"),
                    _buildKey("2"),
                    _buildKey("3"),
                    _buildKey("4"),
                    _buildKey("5"),
                    _buildKey("6"),
                    _buildKey("7"),
                    _buildKey("8"),
                    _buildKey("9"),
                    _buildKey("00"),
                    _buildKey("0"),
                    _buildKey("", isDelete: true),
                  ],
                ),
              ),
            ),
            
            const Spacer(flex: 2),
            
            // Top Up Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                height: 56,
                child: Obx(() => ElevatedButton(
                  onPressed: controller.isTopping.value ? null : controller.topUpCard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: AppColors.primaryColor.withOpacity(0.6),
                  ),
                  child: controller.isTopping.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : TextBold(
                          "Top Up",
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(String text, {bool isDelete = false}) {
    return InkWell(
      onTap: () => isDelete ? controller.removeDigit() : controller.addDigit(text),
      // borderRadius: BorderRadius.circular(50),
      customBorder: CircleBorder(),
      child: Container(
        decoration: BoxDecoration(
          color: isDelete ? Colors.transparent : const Color.fromARGB(255, 253, 253, 253),
          shape: BoxShape.circle
        ),
        child: Center(
          child: isDelete
              ? Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryColor, width: 1.5),
                  ),
                  child: const Icon(Icons.close, size: 24, color: AppColors.primaryColor),
                )
              : TextSemiBold(
                  text,
                  fontSize: 32,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
        ),
      ),
    );
  }

}

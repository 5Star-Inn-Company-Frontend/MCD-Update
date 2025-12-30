import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
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
        title: "Top UP",
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Gap(30),
          
          // Amount Display
          Obx(() => TextBold(
            "${controller.displayCurrency}${controller.formattedEnteredAmount}",
            fontSize: 36,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w600,
          )),
          
          const Gap(40),
          
          // Currency Exchange Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => TextSemiBold(
                  controller.isDollar.value ? "\$1" : "₦${AmountUtil.formatFigure(controller.exchangeRate)}",
                  fontSize: 14,
                  color: AppColors.primaryColor,
                )),
                InkWell(
                  onTap: controller.toggleCurrency,
                  child: const Icon(
                    Icons.swap_horiz,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                Obx(() => TextSemiBold(
                  controller.isDollar.value ? "₦${AmountUtil.formatFigure(controller.exchangeRate)}" : "\$1",
                  fontSize: 14,
                  color: AppColors.primaryColor,
                )),
              ],
            ),
          ),
          
          const Gap(40),
          
          // Custom Keypad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: 20,
              crossAxisSpacing: 40,
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
          
          const Gap(30),
          
          // Top Up Button
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.topUpCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: TextBold(
                  "Top Up",
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String text, {bool isDelete = false}) {
    return InkWell(
      onTap: () => isDelete ? controller.removeDigit() : controller.addDigit(text),
      child: Center(
        child: isDelete
            ? Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryColor, width: 2),
                ),
                child: const Icon(Icons.backspace_outlined, size: 22, color:AppColors.primaryColor),
              )
            : TextSemiBold(
                text,
                fontSize: 28,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
      ),
    );
  }

}

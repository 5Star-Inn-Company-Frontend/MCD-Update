import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  
                  // Amount Display
                  Center(
                    child: Column(
                      children: [
                        TextSemiBold(
                          'Enter Amount',
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        const Gap(12),
                        Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextBold(
                            '\$',
                            fontSize: 32,
                            color: AppColors.primaryColor,
                          ),
                          const Gap(4),
                          TextBold(
                            controller.enteredAmount.value.isEmpty 
                                ? '0' 
                                : controller.enteredAmount.value,
                            fontSize: 48,
                            color: Colors.black87,
                          ),
                        ],
                      )),
                      const Gap(12),
                      TextSemiBold(
                        'Min \$1 to Max \$1,500',
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ],
                    ),
                  ),
                  const Gap(40),
                ],
              ),
            ),
          ),
          
          // Keypad Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                _buildKeypadRow(['1', '2', '3']),
                const Gap(12),
                _buildKeypadRow(['4', '5', '6']),
                const Gap(12),
                _buildKeypadRow(['7', '8', '9']),
                const Gap(12),
                _buildKeypadRow(['.', '0', 'backspace']),
                const Gap(20),
                
                // Top Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
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
                      'Top Up',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((digit) {
        if (digit == 'backspace') {
          return _buildBackspaceButton();
        }
        return _buildKeypadButton(digit);
      }).toList(),
    );
  }

  Widget _buildKeypadButton(String digit) {
    return InkWell(
      onTap: () => controller.addDigit(digit),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: TextBold(
            digit,
            fontSize: 24,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return InkWell(
      onTap: controller.removeDigit,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.black87,
            size: 24,
          ),
        ),
      ),
    );
  }
}

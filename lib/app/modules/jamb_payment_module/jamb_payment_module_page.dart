import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './jamb_payment_module_controller.dart';

class JambPaymentModulePage extends GetView<JambPaymentModuleController> {
    
    const JambPaymentModulePage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: const PaylonyAppBarTwo(
              title: "Verify Account",
              elevation: 0,
              centerTitle: false,
              actions: [],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow("Service", "PAYTV"),
                        const Gap(12),
                        _buildInfoRow("Network", "JAMB"),
                        const Gap(12),
                        _buildInfoRow("Amount", "₦${controller.amount}"),
                        const Gap(12),
                        _buildInfoRow("ATM/Wallet", "${controller.atmFee.toStringAsFixed(2)}/₦${controller.walletFee.toStringAsFixed(2)}"),
                        const Gap(12),
                        _buildInfoRow(
                          "Total Due", 
                          "₦${controller.totalDue.toStringAsFixed(2)}",
                          valueColor: const Color(0xffFF9F9F),
                        ),
                        
                        
                      ],
                    ),
                  ),

                  const Gap(30),

                  TextSemiBold(
                    "Recipient",
                    fontSize: 14,
                  ),
                  const Gap(8),
                  TextFormField(
                    controller: controller.recipientController,
                    keyboardType: TextInputType.phone,
                    decoration: textInputDecoration.copyWith(
                      filled: true,
                      fillColor: const Color(0xffFFFFFF),
                      hintText: "0123456789",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade100)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade100)
                      ),
                    ),
                  ),
                  const Gap(10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextSemiBold(
                      "Account Name: User Name",
                      fontSize: 13,
                      color: AppColors.primaryGrey2,
                    ),
                  ),
                  
                  const Gap(150),
                  Center(
                    child: Obx(() => BusyButton(
                      width: screenWidth(context) * 0.6,
                      title: "Pay",
                      onTap: controller.pay,
                      disabled: controller.isPaying.value,
                    )),
                  ),
                ],
              ),
            ),
        );
    }

    Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold(
            label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.background,
          ),
          TextSemiBold(
            value,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.background,
          ),
        ],
      );
    }
}

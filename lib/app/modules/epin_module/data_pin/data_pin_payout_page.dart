import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/epin_module/data_pin/data_pin_payout_controller.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/fonts.dart';

class DataPinPayoutPage extends GetView<DataPinPayoutController> {
  const DataPinPayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(title: "Payout", centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Gap(30),
            // Network Image
            if (controller.networkImage.isNotEmpty)
              Image.asset(
                controller.networkImage,
                height: 80,
                width: 80,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.phone_android, size: 80),
              ),
            const Gap(10),
            Text(
              controller.networkName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: AppFonts.manRope),
            ),
            const Gap(30),
            _buildDetailsCard(),
            const Gap(40),
            _buildPromoCodeField(),
            const Gap(20),
            _buildPaymentMethod(),
            const Gap(40),
            Obx(() => BusyButton(
              title: "Confirm & Pay",
              onTap: controller.confirmAndPay,
              isLoading: controller.isPaying.value,
            )),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _rowCard('Network Type', controller.networkName),
          _rowCard('Design Type', controller.designType),
          _rowCard('Quantity', controller.quantity),
        ],
      ),
    );
  }

  Widget _buildPromoCodeField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSemiBold('Promo Code', fontSize: 14),
          const Gap(9),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.promoCodeController,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.background,
                    fontFamily: AppFonts.manRope,
                  ),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Enter promo code',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryGrey2,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                ),
              ),
              if (controller.promoCodeController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: controller.clearPromoCode,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSemiBold('Payment Method', fontSize: 14),
        const Gap(9),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffE0E0E0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() => Column(
                children: [
                  RadioListTile(
                    title: Text(
                      'Wallet Balance (₦${controller.walletBalance.value})',
                      style: const TextStyle(fontSize: 14, fontFamily: AppFonts.manRope),
                    ),
                    value: 1,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: controller.selectPaymentMethod,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF5ABB7B),
                  ),
                  const Divider(height: 1),
                  RadioListTile(
                    title: Text(
                      'Mega Bonus (₦${controller.bonusBalance.value})',
                      style: const TextStyle(fontSize: 14, fontFamily: AppFonts.manRope),
                    ),
                    value: 2,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: controller.selectPaymentMethod,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF5ABB7B),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Widget _rowCard(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold(title, fontSize: 15),
          Text(subtitle, style: const TextStyle(fontSize: 15, fontFamily: AppFonts.manRope)),
        ],
      ),
    );
  }
}
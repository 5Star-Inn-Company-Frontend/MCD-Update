import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/modules/electricity_module/electricity_module_controller.dart';
import 'package:mcd/app/modules/electricity_payout_module/electricity_payout_module_controller.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/fonts.dart';

class ElectricityPayoutPage extends GetView<ElectricityPayoutController> {
  const ElectricityPayoutPage({super.key});

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
            // Provider Image
            _buildProviderImage(),
            const Gap(10),
            Text(
              controller.provider.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: AppFonts.manRope),
            ),
            const Gap(30),
            _buildDetailsCard(),
            const Gap(20),
            _buildPointsSwitch(),
            const Gap(20),
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

  Widget _buildProviderImage() {
    try {
      final electricityController = Get.find<ElectricityModuleController>();
      final imageUrl = electricityController.providerImages[controller.provider.name] ?? 
                       electricityController.providerImages['DEFAULT']!;
      return Image.asset(
        imageUrl,
        height: 80,
        width: 80,
        errorBuilder: (context, error, stackTrace) => 
          const Icon(Icons.bolt, size: 80, color: AppColors.primaryColor),
      );
    } catch (e) {
      return const Icon(Icons.bolt, size: 80, color: AppColors.primaryColor);
    }
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
          _rowCard('Biller Name', controller.provider.name),
          _rowCard('Payment Type', controller.paymentType),
          _rowCard('Account Name', controller.customerName),
          _rowCard('Meter Number', controller.meterNumber),
          _rowCard('Amount', '₦${controller.amount.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _buildPointsSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold('Points', fontSize: 14),
          Row(
            children: [
              Obx(() => Text(
                    '₦${controller.pointsBalance.value} available',
                    style: const TextStyle(fontSize: 14, fontFamily: AppFonts.manRope),
                  )),
              const Gap(8),
              Obx(() => Switch(
                    value: controller.usePoints.value,
                    onChanged: controller.toggleUsePoints,
                    activeColor: AppColors.primaryColor,
                  )),
            ],
          ),
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
                  RadioListTile<int>(
                    title: Text(
                      'Wallet Balance (₦${controller.walletBalance.value}.00)',
                      style: GoogleFonts.roboto(fontSize: 14),
                    ),
                    value: 1,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: (value) => controller.selectPaymentMethod(value),
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                    activeColor: const Color(0xFF5ABB7B),
                  ),
                  const Divider(height: 1),
                  RadioListTile<int>(
                    title: Text(
                      'Mega Bonus (₦${controller.bonusBalance.value}.00)',
                      style: const TextStyle(fontSize: 14),
                    ),
                    value: 2,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: (value) => controller.selectPaymentMethod(value),
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
          Flexible(
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 15, fontFamily: AppFonts.manRope),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
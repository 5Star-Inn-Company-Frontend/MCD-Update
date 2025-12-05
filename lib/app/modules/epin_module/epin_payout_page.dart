import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/epin_module/epin_payout_controller.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';

class EpinPayoutPage extends GetView<EpinPayoutController> {
  const EpinPayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.phone_android, size: 80),
              ),
            const Gap(10),
            Text(
              controller.networkName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Gap(30),
            _buildDetailsCard(),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSemiBold('Promo Code', fontSize: 13),
        const Gap(9),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffE0E0E0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.promoCodeController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter promo code',
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
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSemiBold('Payment Method', fontSize: 13),
        const Gap(9),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffE0E0E0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() => Column(
                children: [
                  RadioListTile(
                    title: Text('Wallet Balance (₦${controller.walletBalance.value})'),
                    value: 1,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: controller.selectPaymentMethod,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    activeColor: const Color(0xFF5ABB7B),
                  ),
                  const Divider(height: 1),
                  RadioListTile(
                    title: Text('Mega Bonus (₦${controller.bonusBalance.value})'),
                    value: 2,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: controller.selectPaymentMethod,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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
          Text(subtitle, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

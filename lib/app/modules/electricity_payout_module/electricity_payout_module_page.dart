import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/electricity_payout_module/electricity_payout_module_controller.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';

class ElectricityPayoutPage extends GetView<ElectricityPayoutController> {
  const ElectricityPayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: "Payout", centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Gap(30),
            Text('₦${controller.amount}', style: const TextStyle(fontSize: 20)),
            const Gap(30),
            _buildDetailsCard(),
            const Gap(20),
            _buildPointsSwitch(),
            const Gap(20),
            _buildPaymentMethod(),
            const Gap(40),
            Obx(() => BusyButton(
              title: "Confirm & Pay", 
              onTap: controller.confirmAndPay,
              isLoading: controller.isPaying.value,
            )),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffE0E0E0))),
      child: Column(
        children: [
          _rowCard('Amount', '₦${controller.amount}'),
          _rowCard('Biller Name', controller.provider.name),
          _rowCard('Account Name', controller.customerName),
          _rowCard('Account Number', controller.meterNumber),
          _rowCard('Payment Type', controller.paymentType),
        ],
      ),
    );
  }

  Widget _buildPointsSwitch() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffE0E0E0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold('Points', fontSize: 15),
          Row(children: [
            const Text('₦0.00 available'),
            Obx(() => Switch(
                  value: controller.usePoints.value,
                  onChanged: controller.toggleUsePoints,
                )),
          ]),
        ],
      ),
    );
  }
  
  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSemiBold('Payment Method', fontSize: 13),
        const Gap(9),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xffE0E0E0))),
          child: Obx(() => Column(
                children: [
                  RadioListTile(
                    title: const Text('Wallet Balance (₦0.00)'),
                    value: 1,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: controller.selectPaymentMethod,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile(
                    title: const Text('Mega Bonus (₦0.00)'),
                    value: 2,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: controller.selectPaymentMethod,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
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
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/cable_module/cable_module_controller.dart';
import 'package:mcd/app/modules/cable_payout_module/cable_payout_module_controller.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';

class CablePayoutPage extends GetView<CablePayoutController> {
  const CablePayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: "Payout"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(30),
            Image.asset(
              Get.find<CableModuleController>().providerImages[controller.provider.name] ?? '',
              height: 41, width: 41
            ),
            Text(
              controller.provider.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Gap(30),
            _buildDetailsCard(),
            const Gap(20),
            _buildMoreDetailsCard(),
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
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffE0E0E0))),
      child: Column(
        children: [
          _rowCard('Account Name', controller.customerName),
          const Gap(15),
          _rowCard('Biller Name', controller.provider.name),
          const Gap(15),
          _rowCard('Smartcard Number', controller.smartCardNumber),
        ],
      ),
    );
  }
  
  Widget _buildMoreDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffE0E0E0))),
      child: Column(
        children: [
           _rowCard('Selected Bouquet', controller.package.name),
            const Gap(15),
            _rowCard('Bouquet Price', '₦${controller.package.amount}'),
            const Gap(15),
            _rowCard('Duration', '${controller.package.duration} Month(s)'),
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
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xffE0E0E0))),
          child: Obx(()=> Column(
            children: [
              RadioListTile(
                title: const Text('Wallet Balance (₦0.00)'),
                value: 1,
                groupValue: controller.selectedPaymentMethod.value,
                onChanged: controller.selectPaymentMethod,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile(
                title: const Text('Mega Bonus (₦0.00)'),
                value: 2,
                groupValue: controller.selectedPaymentMethod.value,
                onChanged: controller.selectPaymentMethod,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ],
          )),
        ),
      ],
    );
  }

  Widget _rowCard(String title, String subtitle) {
    return Row(
      children: [
        TextSemiBold(title, fontSize: 15),
        const Spacer(),
        Text(subtitle, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
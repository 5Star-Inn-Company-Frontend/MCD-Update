import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/data_payout_module/data_payout_module_controller.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';

class DataPayoutPage extends GetView<DataPayoutController> {
  const DataPayoutPage({super.key});

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
                height: 60,
                width: 60,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.data_usage, size: 60),
              ),
            const Gap(10),
            Text(
              controller.networkProvider.name.toUpperCase(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Gap(30),
            _buildDetailsCard(),
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
          _rowCard('Plan', controller.dataPlan.name),
          _rowCard('Amount', '₦${controller.dataPlan.price}'),
          _rowCard('Phone Number', controller.phoneNumber),
          _rowCard('Network', controller.networkProvider.name.toUpperCase()),
          // _rowCard('Duration', '${controller.dataPlan.} days'),
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
                    title: Text('Wallet Balance (₦${controller.walletBalance.value})'),
                    value: 1,
                    groupValue: controller.selectedPaymentMethod.value,
                    onChanged: controller.selectPaymentMethod,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile(
                    title: Text('Mega Bonus (₦${controller.bonusBalance.value})'),
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

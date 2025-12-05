import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/airtime_payout_module/airtime_payout_module_controller.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';

class AirtimePayoutPage extends GetView<AirtimePayoutController> {
  const AirtimePayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: "Payout", centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Gap(30),
            
            if (controller.isMultiple) 
              _buildMultipleAirtimeHeader()
            else 
              _buildSingleAirtimeHeader(),
            
            const Gap(30),
            
            if (controller.isMultiple)
              _buildMultipleDetailsCard()
            else
              _buildDetailsCard(),
              
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
  
  Widget _buildSingleAirtimeHeader() {
    return Column(
      children: [
        if (controller.networkImage != null && controller.networkImage!.isNotEmpty)
          Image.asset(
            controller.networkImage!,
            height: 60,
            width: 60,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.phone_android, size: 60),
          ),
        const Gap(10),
        Text(
          controller.provider!.network.toUpperCase(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
  
  Widget _buildMultipleAirtimeHeader() {
    final totalAmount = controller.multipleList?.fold<double>(
      0, (sum, item) => sum + double.parse(item['amount'])
    ) ?? 0;
    
    return Column(
      children: [
        const Icon(Icons.people_alt, size: 60, color: Color(0xFF5ABB7B)),
        const Gap(10),
        Text(
          'Multiple Airtime',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Gap(5),
        Text(
          '${controller.multipleList?.length ?? 0} Recipients',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const Gap(10),
        Text(
          '₦${totalAmount.toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5ABB7B),
          ),
        ),
      ],
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
          _rowCard('Amount', '₦${controller.amount}'),
          _rowCard('Phone Number', controller.phoneNumber ?? 'N/A'),
          _rowCard('Network', controller.provider?.network.toUpperCase() ?? 'N/A'),
        ],
      ),
    );
  }
  
  Widget _buildMultipleDetailsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSemiBold('Recipients', fontSize: 15),
        const Gap(10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.multipleList?.length ?? 0,
          separatorBuilder: (_, __) => const Gap(8),
          itemBuilder: (context, index) {
            final item = controller.multipleList![index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffE0E0E0)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset(
                    item['networkImage'],
                    width: 30,
                    height: 30,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['phoneNumber'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          item['provider'].network.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₦${item['amount']}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5ABB7B),
                    ),
                  ),
                ],
              ),
            );
          },
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

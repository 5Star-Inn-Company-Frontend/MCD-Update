import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/modules/electricity_module/model/electricity_provider_model.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './electricity_module_controller.dart';

class ElectricityModulePage extends GetView<ElectricityModuleController> {
  const ElectricityModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Electricity",
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              child: TextSemiBold("History", fontWeight: FontWeight.w700, fontSize: 16),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProviderDropdown(),
                const Gap(25),
                _buildFormFields(),
                const Gap(25),
                TextSemiBold("Select Amount"),
                const Gap(14),
                _buildAmountGrid(context),
                const Gap(40),
                BusyButton(title: "Pay", onTap: controller.pay),
                const Gap(20),
              ],
            ),
          ),
        )
    );
  }

  Widget _buildProviderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primaryGrey)),
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,));
        }
        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }
        return DropdownButtonHideUnderline(
        child: DropdownButton2<ElectricityProvider>(
          isExpanded: true,
          value: controller.selectedProvider.value,
          items: controller.electricityProviders.map((provider) {
            final imageUrl = controller.providerImages[provider.name] ?? controller.providerImages['DEFAULT']!;
            return DropdownMenuItem<ElectricityProvider>(
              value: provider,
              child: Row(children: [
                Image.asset(imageUrl, width: 40, height: 40),
                const Gap(10),
                Text(provider.name),
              ]),
            );
          }).toList(),
          onChanged: (value) => controller.onProviderSelected(value),
        ),
      );}),
    );
  }

  Widget _buildFormFields() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffF1F1F1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Item'),
          const Gap(6),
          DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              value: controller.selectedPaymentType.value,
              items: controller.paymentTypes
                  .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
                  .toList(),
              onChanged: (value) => controller.onPaymentTypeSelected(value),
              buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
            ),
          ),
          const Divider(),
          const Gap(5),
          Text('Meter Number'),
          const Gap(10),
          TextFormField(
            controller: controller.meterNoController,
            validator: (value) {
              if (value == null || value.isEmpty) return "Meter No needed";
              if (value.length < 5) return "Meter no not valid";
              return null;
            },
            decoration: const InputDecoration(
                suffix: Icon(Icons.cancel_rounded), hintText: 'Meter Number'),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountGrid(BuildContext context) {
    return Container(
      height: screenHeight(context) * 0.27,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffF1F1F1))),
      child: Column(
        children: [
          Flexible(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 3 / 1.3,
              ),
              children: [
                _amountCard('1000'),_amountCard('2000'),_amountCard('3000'),
                _amountCard('5000'),_amountCard('10000'),_amountCard('20000'),
              ],
            ),
          ),
          Row(
            children: [
              const Text("₦"),
              const Gap(8),
              Flexible(
                child: TextFormField(
                  controller: controller.amountController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Amount needed";
                    return null;
                  },
                  decoration: const InputDecoration(hintText: '500.00 - 50,000.00'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountCard(String amount) {
    return TouchableOpacity(
      onTap: () => controller.onAmountSelected(amount),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text('₦$amount', style: const TextStyle(color: AppColors.white)),
        ),
      ),
    );
  }
}
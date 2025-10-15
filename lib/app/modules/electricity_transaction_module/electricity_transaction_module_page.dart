import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/electricity_transaction_module/electricity_transaction_module_controller.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/utils/functions.dart';

class ElectricityTransactionPage extends GetView<ElectricityTransactionController> {
  const ElectricityTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: "Transaction Detail"),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAsset.spiralBg),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                _buildSummaryCard(),
                const Gap(10),
                _buildTokenCard(),
                const Gap(8),
                _buildDetailsCard(isFirst: true),
                const Gap(8),
                _buildDetailsCard(isFirst: false),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: BusyButton(title: "Share Receipt", onTap: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(controller.image, width: 50, height: 50),
            const Gap(8),
            TextSemiBold(controller.name, fontSize: 22),
            const Gap(6),
            TextSemiBold(Functions.money(controller.amount, "N"), fontSize: 22),
            const Gap(10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.check_circle_outline_outlined, color: Colors.green),
              const Gap(4),
              TextSemiBold("Successful", color: Colors.green),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSemiBold("Token"),
        const Gap(4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(border: Border.all(color: Colors.green)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("01234567890987654321"),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextSemiBold("Copy", color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard({required bool isFirst}) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: isFirst
              ? [
                  _itemRow("User ID", "012345678"),
                  _itemRow("Payment Type", "Electricity"),
                  _itemRow("Payment Method", "MCD balance"),
                ]
              : [
                  _itemRow("Transaction ID:", "012345678912345678"),
                  _itemRow("Posted date:", "22:57, Oct 13, 2025"),
                  _itemRow("Transaction date:", "22:58, Oct 13, 2025"),
                ],
        ),
      ),
    );
  }

  Widget _itemRow(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold(name, fontSize: 15),
          TextSemiBold(value, fontSize: 15),
        ],
      ),
    );
  }
}
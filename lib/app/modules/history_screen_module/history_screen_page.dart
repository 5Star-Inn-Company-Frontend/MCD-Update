import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/history_screen_module/history_screen_controller.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/utils/bottom_navigation.dart';
import 'package:mcd/app/widgets/app_bar.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/utils/functions.dart';
import 'package:collection/collection.dart' show ListExtensions;

class HistoryScreenPage extends GetView<HistoryScreenController> {
  const HistoryScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBar(
        title: "Transaction History",
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextBold(
                              "All",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TouchableOpacity(
                                onTap: () => _showFilterDialog(context),
                                child: const Icon(Icons.keyboard_arrow_down))
                          ],
                        )
                      ]),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextBold(
                              "All Status",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TouchableOpacity(
                                onTap: () => _showFilterDialog(context),
                                child: const Icon(Icons.keyboard_arrow_down))
                          ],
                        )
                      ]),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextBold(
                              "Filter",
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            TouchableOpacity(
                                onTap: () => _showFilterDialog(context),
                                child: const Icon(Icons.filter_alt_outlined))
                          ],
                        )
                      ]),
                ),
              ],
            ),
            const Gap(30),
            Divider(color: AppColors.placeholderColor.withOpacity(0.6)),
            Obx(() => TouchableOpacity(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Wrap(
                              children: controller.months
                                  .mapIndexed((index, e) => ListTile(
                                        leading: TextSemiBold(e.toString()),
                                        onTap: () {
                                          controller.selectedValue =
                                              e.toString();
                                          Navigator.pop(context);
                                        },
                                      ))
                                  .toList());
                        });
                  },
                  child: Row(
                    children: [
                      TextSemiBold(controller.selectedValue.toString(),
                          color: Colors.black),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryGrey2,
                      )
                    ],
                  ),
                )),
            const Gap(6),
            const Row(
              children: [
                Text(
                  "In ₦0.00 ",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Gap(10),
                Text(
                  "Out ₦0.00",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Gap(10),
            Divider(color: AppColors.placeholderColor.withOpacity(0.6)),
            ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: controller.transactionModel.length,
                itemBuilder: (context, index) {
                  final value = controller.transactionModel[index];
                  return _transactionCard(
                      context, value.name, value.image, value.amount, value.time);
                }),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(selectedIndex: 1),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: double.infinity,
              decoration: const BoxDecoration(color: Color(0xffFBFBFB)),
              child: Wrap(
                children: [
                  Stack(
                    children: [
                      Center(
                          child: TextBold(
                        "Filter By",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                      Positioned(
                          top: 0,
                          right: 2,
                          child: TouchableOpacity(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.clear,
                                color: AppColors.background,
                              )))
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 20),
                          child: _durationcard(context, "Money in ")),
                      _durationcard(context, "Money out"),
                      _durationcard(context, "All")
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _durationcard(BuildContext context, String time) {
    return TouchableOpacity(
      onTap: () {
        controller.filterBy = time;
        Navigator.pop(context);
      },
      child: Container(
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: AppColors.white, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: TextSemiBold(
            time,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          )),
    );
  }

  Widget _transactionCard(BuildContext context, String title, String image,
      double amount, String time) {
    return ListTile(
      onTap: () {
        print('Navigating to: ${Routes.TRANSACTION_DETAIL_MODULE}');
        print('With arguments: name=$title, amount=$amount');
        Get.toNamed(
          Routes.TRANSACTION_DETAIL_MODULE,
          arguments: {
            'name': title,
            'image': image,
            'amount': amount,
            'paymentType': 'Transaction',
            'userId': 'N/A',
            'customerName': 'N/A',
            'transactionId': 'N/A',
            'packageName': 'N/A',
            'token': 'N/A',
          },
        );
      },
      contentPadding: EdgeInsets.zero,
      leading: Image.asset(
        image,
        width: 80,
        height: 80,
      ),
      title: TextSemiBold(title),
      subtitle: TextSemiBold(time),
      trailing: TextSemiBold(Functions.money(amount, "N")),
    );
  }
}

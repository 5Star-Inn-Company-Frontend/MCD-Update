import 'package:mcd/app/modules/history_screen_module/history_screen_controller.dart';
import 'package:mcd/app/utils/bottom_navigation.dart';
import 'package:mcd/app/widgets/app_bar.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/utils/functions.dart';
import 'package:collection/collection.dart' show ListExtensions;
import 'package:google_fonts/google_fonts.dart';
import 'dart:developer' as dev;

class HistoryScreenPage extends GetView<HistoryScreenController> {
  const HistoryScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBar(
        title: "Transaction History",
      ),
      body: Obx(() => controller.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryColor,))
          : RefreshIndicator(
              color: AppColors.primaryColor,
              backgroundColor: AppColors.white,
              onRefresh: controller.refreshTransactions,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextBold(
                                          controller.filterBy,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        TouchableOpacity(
                                            onTap: () =>
                                                _showFilterDialog(context),
                                            child: const Icon(
                                                Icons.keyboard_arrow_down))
                                      ],
                                    )
                                  ]),
                            )),
                        Obx(() => Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 25),
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextBold(
                                          controller.statusFilter,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        TouchableOpacity(
                                            onTap: () =>
                                                _showStatusDialog(context),
                                            child: const Icon(
                                                Icons.keyboard_arrow_down))
                                      ],
                                    )
                                  ]),
                            )),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
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
                                        child:
                                            const Icon(Icons.filter_alt_outlined))
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
                                                leading:
                                                    TextSemiBold(e.toString()),
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
                    Obx(() => Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "In ",
                                    style: TextStyle(
                                      fontSize: 13, 
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "₦",
                                    style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: Functions.money(controller.totalIn, "").trim(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: "Out ",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "₦",
                                    style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: Functions.money(controller.totalOut, "").trim(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                    const Gap(10),
                    Divider(color: AppColors.placeholderColor.withOpacity(0.6)),
                    Expanded(
                      child: Obx(() {
                        final transactions = controller.filteredTransactions;
                        
                        if (transactions.isEmpty) {
                          return Center(
                            child: TextSemiBold('No transactions found'),
                          );
                        }

                        return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: transactions.length,
                            itemBuilder: (context, index) {
                              final transaction = transactions[index];
                              final icon =
                                  controller.getTransactionIcon(transaction);
                              return _transactionCard(
                                context,
                                transaction.type,
                                icon,
                                transaction.amountValue,
                                transaction.formattedTime,
                                transaction,
                              );
                            });
                      }),
                    ),
                  ],
                ),
              ),
            )),
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
              // decoration: const BoxDecoration(color: Color(0xffFBFBFB)),
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
                          child: _durationcard(context, "Money in")),
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

  void _showStatusDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              width: double.infinity,
              // decoration: const BoxDecoration(color: Color(0xffFBFBFB)),
              child: Wrap(
                children: [
                  Stack(
                    children: [
                      Center(
                          child: TextBold(
                        "Filter By Status",
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
                          child: _statusCard(context, "All Status")),
                      _statusCard(context, "Success"),
                      _statusCard(context, "Pending"),
                      _statusCard(context, "Failed"),
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
              // color: AppColors.white,
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: TextSemiBold(
            time,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          )),
    );
  }

  Widget _statusCard(BuildContext context, String status) {
    return TouchableOpacity(
      onTap: () {
        controller.statusFilter = status;
        Navigator.pop(context);
      },
      child: Container(
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              // color: AppColors.white,
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: TextSemiBold(
            status,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          )),
    );
  }

  Widget _transactionCard(
    BuildContext context,
    String title,
    String image,
    double amount,
    String time,
    dynamic transaction,
  ) {
    return ListTile(
      onTap: () {
        dev.log('With arguments: name=$title, amount=$amount');
        Get.toNamed(
          Routes.TRANSACTION_DETAIL_MODULE,
          arguments: {
            'name': title,
            'image': image,
            'amount': amount,
            'paymentType': transaction.type ?? 'Transaction',
            'userId': transaction.phoneNumber,
            'customerName': transaction.recipient ?? 'N/A',
            'transactionId': transaction.reference ?? 'N/A',
            'packageName': 'N/A',
            'token': 'N/A',
            'date': transaction.date ?? 'N/A',
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
      trailing: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "₦",
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: Functions.money(amount, "").trim(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: AppFonts.manRope
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/constants/fonts.dart';
import './virtual_card_transactions_controller.dart';

class VirtualCardTransactionsPage extends GetView<VirtualCardTransactionsController> {
  const VirtualCardTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Transactions",
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            
            // Virtual Card Display
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 50 * (1 - value)),
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Image.asset(
                'assets/images/virtual_card/vc_transaction.png',
                // width: 500,
                // height: 190,
                fit: BoxFit.contain,
              ),
            ),
            const Gap(30),
            
            Text(
              'Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: AppFonts.manRope,
              ),
            ),
        
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = controller.transactions[index];
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(50 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: _buildTransactionItem(transaction),
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isDebit = transaction['isDebit'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(  vertical: 12),
      // decoration: BoxDecoration(
      //   color: Colors.grey.shade50,
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(color: Colors.grey.shade200),
      // ),
      child: Row(
        children: [
          
          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemiBold(
                  transaction['title'] ?? '',
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(4),
                TextSemiBold(
                  transaction['date'] ?? '',
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          
          // Amount
          TextBold(
            transaction['amount'] ?? '',
            fontSize: 16,
            color: isDebit 
                ? const Color(0xFFF44336) 
                : AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}

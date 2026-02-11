import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mcd/app/modules/virtual_card/models/virtual_card_transaction_model.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/shimmer_loading.dart';
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
            Obx(() {
              if (controller.cardModel == null) {
                return const SizedBox.shrink();
              }
              
              final card = controller.cardModel!;
              final balance = controller.cardBalance.value;
              
              return TweenAnimationBuilder<double>(
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
                child: _buildVirtualCard(
                  balance: '\$${balance.toStringAsFixed(2)}',
                  cardNumber: card.masked,
                  color: _getCardColor(card.brand),
                  brand: card.brand,
                  isActive: card.status == 1,
                ),
              );
            }),
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildTransactionShimmer();
                }
                if (controller.transactions.isEmpty) {
                  return Center(
                    child: TextSemiBold(
                      'No transactions yet',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  );
                }
                return ListView.builder(
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
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(VirtualCardTransactionModel transaction) {
    final isDebit = transaction.type.toLowerCase() == 'debit';
    final formattedDate = DateFormat('MMM dd, yyyy hh:mm a').format(transaction.createdAt);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemiBold(
                  transaction.description,
                  fontSize: 14,
                  color: Colors.black87,
                ),
                const Gap(4),
                TextSemiBold(
                  formattedDate,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          TextBold(
            '${isDebit ? '-' : '+'}\$${transaction.amount.toStringAsFixed(2)}',
            fontSize: 16,
            color: isDebit 
                ? const Color(0xFFF44336) 
                : AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildVirtualCard({
    required String balance,
    required String cardNumber,
    required Color color,
    required bool isActive,
    String? brand,
  }) {
    String formattedCardNumber = _formatCardNumber(cardNumber);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Base gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color,
                    color.withOpacity(0.85),
                  ],
                ),
              ),
            ),

            // Wave pattern layer 1 (darkest)
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 400,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.3),
                ),
              ),
            ),

            // Wave pattern layer 2
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 350,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.25),
                ),
              ),
            ),

            // Wave pattern layer 3 (lighter)
            Positioned(
              top: -60,
              right: -100,
              child: Container(
                width: 300,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                ),
              ),
            ),

            // Bottom wave layer 1
            Positioned(
              bottom: -150,
              left: -100,
              child: Container(
                width: 350,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            ),

            // Bottom wave layer 2
            Positioned(
              bottom: -120,
              left: -50,
              child: Container(
                width: 300,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.05),
                ),
              ),
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand Logo and Contactless Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (brand != null && brand.toLowerCase() == 'mastercard')
                        // Mastercard logo (two circles)
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFEB001B),
                              ),
                            ),
                            Transform.translate(
                              offset: const Offset(-12, 0),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF79E1B),
                                ),
                              ),
                            ),
                          ],
                        )
                      else if (brand != null)
                        TextBold(
                          brand.toUpperCase(),
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        )
                      else
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.credit_card,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      const Icon(
                        Icons.contactless_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Balance
                  TextBold(
                    balance,
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  const Gap(16),

                  // Card Number
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextSemiBold(
                      formattedCardNumber,
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCardNumber(String cardNumber) {
    String cleaned = cardNumber.replaceAll(RegExp(r'[\s\-\*]'), '');
    
    if (cardNumber.contains('*')) {
      if (cardNumber.split(' ').length == 4) {
        return cardNumber;
      }
      return cardNumber.replaceAll(RegExp(r'\s+'), ' ').trim();
    }
    
    if (cleaned.length >= 16) {
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 8)} ${cleaned.substring(8, 12)} ${cleaned.substring(12, 16)}';
    } else if (cleaned.length >= 12) {
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 8)} ${cleaned.substring(8, 12)} ${cleaned.substring(12)}';
    } else if (cleaned.length >= 8) {
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 8)} ${cleaned.substring(8)}';
    } else if (cleaned.length >= 4) {
      return '${cleaned.substring(0, 4)} ${cleaned.substring(4)}';
    }
    
    return cardNumber;
  }

  Color _getCardColor(String? brand) {
    if (brand == null) return Colors.blueGrey;
    switch (brand.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1E3A8A); // Blue
      case 'mastercard':
        return AppColors.primaryGreen;
      case 'verve':
        return AppColors.primaryGreen;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildTransactionShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading(
                        width: double.infinity,
                        height: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const Gap(6),
                      ShimmerLoading(
                        width: 120,
                        height: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                ShimmerLoading(
                  width: 80,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

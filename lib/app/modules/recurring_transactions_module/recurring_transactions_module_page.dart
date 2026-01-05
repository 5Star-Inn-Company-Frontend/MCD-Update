import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/utils/functions.dart';
import 'package:intl/intl.dart';
import './recurring_transactions_module_controller.dart';

class RecurringTransactionsModulePage extends GetView<RecurringTransactionsModuleController> {
  const RecurringTransactionsModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: 'Recurring Transactions',
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Create new recurring section (only show if transaction ref is provided)
          if (controller.transactionRef != null) ...[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.repeat,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextSemiBold(
                              'Add to Recurring',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            const Gap(4),
                            Text(
                              controller.transactionName ?? 'Transaction',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryGrey2,
                                fontFamily: AppFonts.manRope,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (controller.transactionAmount != null) ...[
                    const Gap(12),
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          size: 16,
                          color: AppColors.primaryColor,
                        ),
                        const Gap(6),
                        Text(
                          '₦${Functions.money(controller.transactionAmount!, "")}',
                          style: GoogleFonts.arimo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Gap(16),
                  Obx(() => BusyButton(
                    title: 'Set Recurring Frequency',
                    onTap: () => controller.showFrequencyDialog(),
                    isLoading: controller.isCreating.value,
                  )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                color: AppColors.primaryGrey2.withOpacity(0.2),
                thickness: 1,
              ),
            ),
          ],
          
          // Recurring transactions list header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextSemiBold(
                  'Your Recurring Transactions',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                Obx(() => IconButton(
                  onPressed: controller.isLoadingList.value
                      ? null
                      : () => controller.fetchRecurringTransactions(),
                  icon: controller.isLoadingList.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryColor,
                          ),
                        )
                      : const Icon(Icons.refresh),
                  color: AppColors.primaryColor,
                )),
              ],
            ),
          ),
          
          // Recurring transactions list
          Expanded(
            child: Obx(() {
              if (controller.isLoadingList.value && controller.recurringTransactions.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }
              
              if (controller.recurringTransactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.repeat_outlined,
                        size: 64,
                        color: AppColors.primaryGrey2.withOpacity(0.5),
                      ),
                      const Gap(16),
                      TextSemiBold(
                        'No Recurring Transactions',
                        fontSize: 16,
                        color: AppColors.primaryGrey2,
                      ),
                      const Gap(8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Set up recurring transactions to automate your regular payments',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primaryGrey2.withOpacity(0.7),
                            fontFamily: AppFonts.manRope,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () => controller.fetchRecurringTransactions(),
                color: AppColors.primaryColor,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.recurringTransactions.length,
                  separatorBuilder: (context, index) => const Gap(12),
                  itemBuilder: (context, index) {
                    final transaction = controller.recurringTransactions[index];
                    return _buildRecurringItem(transaction);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecurringItem(RecurringTransaction transaction) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGrey2.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.showOptionsMenu(transaction),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    transaction.frequency == 'DAILY'
                        ? Icons.today
                        : transaction.frequency == 'WEEKLY'
                            ? Icons.calendar_view_week
                            : Icons.calendar_month,
                    color: AppColors.primaryColor,
                    size: 24,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextSemiBold(
                            transaction.name ?? transaction.type ?? 'Transaction',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),

                          Gap(8),

                          if (transaction.amount != null) ...[
                            const Gap(4),
                            Text(
                              '₦${Functions.money(transaction.amount!, "")}',
                              style: GoogleFonts.arimo(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Gap(4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getFrequencyColor(transaction.frequency).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _formatFrequency(transaction.frequency),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _getFrequencyColor(transaction.frequency),
                                fontFamily: AppFonts.manRope,
                              ),
                            ),
                          ),
                          const Gap(8),
                          Text(
                            transaction.ref,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryGrey2.withOpacity(0.7),
                              fontFamily: AppFonts.manRope,
                            ),
                          ),
                        ],
                      ),
                      
                      // next scheduled date
                      if (transaction.nextSchedule != null) ...[
                        const Gap(6),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: AppColors.primaryGrey2.withOpacity(0.7),
                            ),
                            const Gap(4),
                            Text(
                              'Next: ${_formatDate(transaction.nextSchedule!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryGrey2.withOpacity(0.7),
                                fontFamily: AppFonts.manRope,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => controller.showOptionsMenu(transaction),
                  icon: const Icon(Icons.more_vert),
                  color: AppColors.primaryGrey2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _formatFrequency(String frequency) {
    switch (frequency.toUpperCase()) {
      case 'DAILY':
        return 'Daily';
      case 'WEEKLY':
        return 'Weekly';
      case 'MONTHLY':
        return 'Monthly';
      default:
        return frequency;
    }
  }
  
  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }
  
  Color _getFrequencyColor(String frequency) {
    switch (frequency.toUpperCase()) {
      case 'DAILY':
        return Colors.green;
      case 'WEEKLY':
        return Colors.orange;
      case 'MONTHLY':
        return Colors.blue;
      default:
        return AppColors.primaryColor;
    }
  }
}

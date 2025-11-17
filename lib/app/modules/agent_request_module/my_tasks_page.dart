import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/core/constants/fonts.dart';

class MyTasksPage extends StatelessWidget {
  const MyTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const PaylonyAppBarTwo(
        title: 'My Tasks',
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Monthly Plan Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextBold(
                        'Monthly plan',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1976D2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(4),
                            const Text(
                              '5 days left',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF1976D2),
                                fontWeight: FontWeight.w500,
                                fontFamily: AppFonts.manRope,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  const Text(
                    'Set your business up for success by completing recommended tasks.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGrey2,
                      height: 1.4,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                  const Gap(16),
                  const Text(
                    'Complete at least 4 tasks to finish this plan.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                  const Gap(16),
                  // Progress Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '0 of 4 tasks completed',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryGrey2,
                          fontFamily: AppFonts.manRope,
                        ),
                      ),
                      TextSemiBold(
                        'Monthly goal',
                        fontSize: 13,
                        color: AppColors.primaryGrey2,
                      ),
                    ],
                  ),
                  const Gap(8),
                  const Text(
                    'Last updated Thu Aug 22, 4:36pm',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGrey2,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                ],
              ),
            ),
            
            const Gap(24),
            
            // Tasks List
            _buildTaskCard(
              icon: Icons.shopping_bag_outlined,
              iconColor: const Color(0xFF4CAF50),
              title: 'Buy 50 MTN data plans',
              subtitle: 'You may see Facebook post impressions of',
              progress: '0 of 50 data',
            ),
            const Gap(12),
            _buildTaskCard(
              icon: Icons.phone_android,
              iconColor: const Color(0xFF2196F3),
              title: 'Buy 20 Airtime',
              subtitle: 'You may see Facebook post impressions of',
              progress: '0 of 20 Airtime',
            ),
            const Gap(12),
            _buildTaskCard(
              icon: Icons.people_outline,
              iconColor: const Color(0xFFFF9800),
              title: 'Refer 10 people',
              subtitle: 'You may see Facebook post impressions of',
              progress: '0 of 10 people',
            ),
            const Gap(12),
            _buildTaskCard(
              icon: Icons.tv,
              iconColor: const Color(0xFF9C27B0),
              title: 'Buy 5 TV subscription',
              subtitle: 'You may see Facebook post impressions of',
              progress: '0 of 5 TV',
            ),
            
            const Gap(32),
            
            // Plan History Section
            TextBold(
              'Plan history',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            const Gap(4),
            const Text(
              'See details from previous plans.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.primaryGrey2,
                fontFamily: AppFonts.manRope,
              ),
            ),
            
            const Gap(16),
            
            // History Items
            _buildHistoryItem(
              dateRange: 'Sun, Aug 18-Sat, Aug 24',
              tasksCompleted: '2 of 6 tasks',
              isExpanded: false,
            ),
            const Gap(12),
            _buildHistoryItem(
              dateRange: 'Sun, Aug 11-Sat, Aug 17',
              tasksCompleted: '1 of 6 tasks',
              isExpanded: false,
            ),
            
            const Gap(40),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextSemiBold(
                  title,
                  fontSize: 14,
                  color: AppColors.textPrimaryColor,
                ),
                const Gap(4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryGrey2,
                    fontFamily: AppFonts.manRope,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(8),
                Text(
                  progress,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryGrey2,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFonts.manRope,
                  ),
                ),
              ],
            ),
          ),
          const Gap(8),
          ElevatedButton(
            onPressed: () {
              // Handle complete now action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Complete Now',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontFamily: AppFonts.manRope,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String dateRange,
    required String tasksCompleted,
    required bool isExpanded,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryGrey.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateRange,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppFonts.manRope,
                ),
              ),
              const Gap(4),
              Text(
                tasksCompleted,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primaryGrey2,
                  fontFamily: AppFonts.manRope,
                ),
              ),
            ],
          ),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: AppColors.primaryGrey2,
          ),
        ],
      ),
    );
  }
}

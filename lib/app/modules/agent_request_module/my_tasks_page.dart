import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/core/constants/fonts.dart';
import './agent_request_module_controller.dart';

class MyTasksPage extends GetView<AgentRequestModuleController> {
  const MyTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch tasks when page loads
    controller.fetchCurrentAgentTasks();
    controller.fetchPreviousAgentTasks();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: const PaylonyAppBarTwo(
        title: 'My Tasks',
        centerTitle: false,
      ),
      body: Obx(() {
        // Loading state
        if (controller.isLoadingTasks.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        // Error state
        if (controller.tasksErrorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.withOpacity(0.5),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    controller.tasksErrorMessage.value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryGrey2,
                      fontFamily: AppFonts.manRope,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(24),
                ElevatedButton(
                  onPressed: controller.retryFetchTasks,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final tasksResponse = controller.currentTasks.value;
        final tasks = tasksResponse?.tasks ?? [];

        // Empty state
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64,
                  color: AppColors.primaryGrey2.withOpacity(0.5),
                ),
                const Gap(16),
                const Text(
                  'No tasks available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryGrey2,
                    fontFamily: AppFonts.manRope,
                  ),
                ),
                const Gap(8),
                const Text(
                  'Your tasks will appear here',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryGrey2,
                    fontFamily: AppFonts.manRope,
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
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
                            Text(
                              '${tasksResponse?.daysLeft ?? 0} days left',
                              style: const TextStyle(
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
                  Text(
                    tasksResponse?.message ?? 'Set your business up for success by completing recommended tasks.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGrey2,
                      height: 1.4,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                  const Gap(16),
                  Text(
                    'Complete at least ${(tasks.length * 0.7).ceil()} tasks to finish this plan.',
                    style: const TextStyle(
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
                      Text(
                        '${tasksResponse?.completedTasksCount ?? 0} of ${tasks.length} tasks completed',
                        style: const TextStyle(
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
                  Text(
                    'Last updated ${tasksResponse?.lastUpdated ?? ""}',
                    style: const TextStyle(
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
            ...tasks.map((task) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTaskCard(
                icon: _getIconForType(task.type),
                iconColor: _getColorForType(task.type),
                title: task.description,
                subtitle: task.typeDisplayName,
                progress: task.progressText,
              ),
            )).toList(),
            
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
      );
    }));
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

  // Helper method to get icon based on task type
  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'airtime':
        return Icons.phone_android;
      case 'data':
        return Icons.shopping_bag_outlined;
      case 'refer':
        return Icons.people_outline;
      case 'tv':
        return Icons.tv;
      default:
        return Icons.check_circle_outline;
    }
  }

  // Helper method to get color based on task type
  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'airtime':
        return const Color(0xFF2196F3); // Blue
      case 'data':
        return const Color(0xFF4CAF50); // Green
      case 'refer':
        return const Color(0xFFFF9800); // Orange
      case 'tv':
        return const Color(0xFF9C27B0); // Purple
      default:
        return AppColors.primaryColor;
    }
  }
}

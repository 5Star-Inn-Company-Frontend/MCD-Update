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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Tasks Section
                if (tasks.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: const Text(
                      'No current tasks available',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryGrey2,
                        fontFamily: AppFonts.manRope,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else ...[
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
                              'Monthly Task',
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
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: (tasksResponse?.daysLeft ?? 0) < 5
                                          ? Colors.red
                                          : const Color(0xFF1976D2),
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
                          tasksResponse?.message ??
                              'Set your business up for success by completing recommended tasks.',
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
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: tasks.isEmpty
                                ? 0
                                : (tasksResponse?.completedTasksCount ?? 0) /
                                    tasks.length,
                            backgroundColor: const Color(0xFFE0E0E0),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.primaryColor),
                            minHeight: 6,
                          ),
                        ),
                        if (tasksResponse != null &&
                            tasksResponse.lastUpdated.isNotEmpty)
                          Text(
                            'Last updated ${tasksResponse.lastUpdated}',
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
                  ...tasks
                      .map((task) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildTaskCard(
                              icon: _getIconForType(task.type),
                              iconColor: _getColorForType(task.type),
                              title: task.description,
                              subtitle: task.typeDisplayName,
                              progress: task.progressText,
                              isCompleted: task.completed == 1,
                              onTap: () =>
                                  controller.handleTaskAction(task.type),
                            ),
                          ))
                      .toList(),
                ],

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
                Obx(() {
                  final previous = controller.previousTasks.value;
                  if (previous == null || previous.tasks.isEmpty) {
                    return const Text(
                      'No history available',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryGrey2,
                        fontFamily: AppFonts.manRope,
                      ),
                    );
                  }

                  final completedCount =
                      previous.tasks.where((t) => t.completed == 1).length;
                  final isExpanded = controller.expandedHistoryIndex.value == 0;

                  return Column(
                    children: [
                      // History header with expand/collapse
                      GestureDetector(
                        onTap: () {
                          controller.expandedHistoryIndex.value =
                              isExpanded ? -1 : 0;
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: isExpanded
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  )
                                : BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primaryGrey.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      previous.date,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppFonts.manRope,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '$completedCount of ${previous.tasks.length} tasks',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primaryGrey2,
                                  fontFamily: AppFonts.manRope,
                                ),
                              ),
                              const Gap(8),
                              // Progress bar
                              SizedBox(
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: previous.tasks.isEmpty
                                        ? 0
                                        : completedCount /
                                            previous.tasks.length,
                                    backgroundColor: const Color(0xFFE0E0E0),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            AppColors.primaryColor),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const Gap(8),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primaryGrey2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Expanded tasks
                      if (isExpanded)
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            border: Border.all(
                              color: AppColors.primaryGrey.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: previous.tasks
                                .map((task) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: AppColors.primaryGrey
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: _getColorForType(task.type)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Icon(
                                              _getIconForType(task.type),
                                              color:
                                                  _getColorForType(task.type),
                                              size: 18,
                                            ),
                                          ),
                                          const Gap(12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  task.description,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors
                                                        .textPrimaryColor,
                                                    fontFamily:
                                                        AppFonts.manRope,
                                                  ),
                                                ),
                                                const Gap(2),
                                                Text(
                                                  '${task.current} of ${task.goal} ${task.type}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        AppColors.primaryGrey2,
                                                    fontFamily:
                                                        AppFonts.manRope,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (task.completed == 1)
                                            const Icon(
                                              Icons.check_circle,
                                              color: Color(0xFF4CAF50),
                                              size: 20,
                                            )
                                          else
                                            const Icon(
                                              Icons.radio_button_unchecked,
                                              color: AppColors.primaryGrey2,
                                              size: 20,
                                            ),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                    ],
                  );
                }),

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
    required bool isCompleted,
    required VoidCallback onTap,
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
          const Gap(8),
          if (isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.manRope,
                ),
              ),
            )
          else
            ElevatedButton(
              onPressed: onTap,
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

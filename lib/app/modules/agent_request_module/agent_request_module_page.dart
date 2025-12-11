import 'package:mcd/core/import/imports.dart';
import './agent_request_module_controller.dart';
import './my_tasks_page.dart';

class AgentRequestModulePage extends GetView<AgentRequestModuleController> {
    
    const AgentRequestModulePage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: AppColors.white,
            appBar: const PaylonyAppBarTwo(
              title: 'Agent Request',
              centerTitle: false,
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Steps Section
                    _buildStepCard(
                      stepNumber: '1',
                      title: 'Provide personal details',
                      isCompleted: controller.step1.value,
                      onTap: () => Get.toNamed(Routes.AGENT_PERSONAL_INFO),
                    ),
                    const Gap(16),
                    _buildStepCard(
                      stepNumber: '2',
                      title: 'Provide copy of signed document sent to your email',
                      isCompleted: controller.step2.value,
                      onTap: controller.handleStep2Navigation,
                    ),
                    const Gap(16),
                    _buildStepCard(
                      stepNumber: '3',
                      title: 'Awaiting verification',
                      isCompleted: controller.step3.value,
                      onTap: null,
                    ),
                    
                    const Gap(40),
                    
                    // See Benefits Button
                    Center(
                      child: GestureDetector(
                        onTap: () => _showBenefitsBottomSheet(context),
                        child: TextSemiBold(
                          'See Benefits',
                          fontSize: 16,
                          color: AppColors.primaryColor,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    
                    const Gap(40),
                    
                    // Next Button
                    Center(
                      child: BusyButton(
                        title: 'Next',
                        onTap: () {
                          Get.toNamed(Routes.AGENT_PERSONAL_INFO);
                        },
                        width: screenWidth(context) * 0.8,
                      ),
                    ),
                  ],
                ),
              );
            }),
        );
    }

    Widget _buildStepCard({
      required String stepNumber,
      required String title,
      required bool isCompleted,
      VoidCallback? onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(
              color: AppColors.primaryGrey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextSemiBold(
                      'Step $stepNumber',
                      fontSize: 14,
                    ),
                    const Gap(4),
                    TextSemiBold(
                      title,
                      fontSize: 15,
                      color: AppColors.textPrimaryColor,
                    ),
                  ],
                ),
              ),
              isCompleted ? const Icon(
                  Icons.check_circle,
                  color: AppColors.primaryColor,
                  size: 24,
                ) : const Icon(
                  Icons.radio_button_unchecked,
                  color: AppColors.primaryGrey,
                  size: 24,
                ),
            ],
          ),
        ),
      );
    }

    void _showBenefitsBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: AppColors.white,
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGrey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Gap(20),
                
                Image.asset(
                  'assets/images/mcdagentlogo.png',
                  width: 60,
                  height: 60,
                ),
                const Gap(8),
                const Text(
                  'Your compensation package as an Agent will be each and every successful sale & tv subscription purchased within a month and according to level breakdown is shown below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryGrey2,
                    fontFamily: AppFonts.manRope
                  ),
                ),
                
                const Gap(24),
                
                // Levels List
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      _buildLevelItem('Level 1: #3'),
                      _buildLevelItem('Level 2: #5'),
                      _buildLevelItem('Level 3: #8'),
                      _buildLevelItem('Level 4: #9'),
                      _buildLevelItem('Level 5: #10'),
                      _buildLevelItem('Level 6: #13'),
                      _buildLevelItem('Level 7: #15'),
                      _buildLevelItem('Level 8: #20'),
                      _buildLevelItem('...and so on'),
                    ],
                  ),
                ),
                
                // const Gap(16),
                
                // My Tasks Button
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const MyTasksPage());
                    },
                    child: TextSemiBold(
                      'My Tasks',
                      fontSize: 16,
                      color: AppColors.primaryColor,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildLevelItem(String text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 14),
            const Gap(12),
            TextSemiBold(
              text,
              fontSize: 14,
              color: AppColors.textPrimaryColor,
            ),
          ],
        ),
      );
    }
}
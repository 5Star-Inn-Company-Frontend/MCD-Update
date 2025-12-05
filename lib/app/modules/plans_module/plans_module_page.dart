import 'package:mcd/app/modules/plans_module/plans_module_controller.dart';
import 'package:mcd/core/import/imports.dart';

class PlansModulePage extends GetView<PlansModuleController> {
  const PlansModulePage({super.key, this.isAppbar = true});

  final bool? isAppbar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isAppbar == true
          ? const PaylonyAppBarTwo(
              title: "Plans",
              centerTitle: false,
            )
          : null,
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryGreen,
            ),
          );
        }

        if (controller.plans.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 64,
                  color: AppColors.primaryGrey,
                ),
                const Gap(16),
                TextSemiBold(
                  'No plans available',
                  fontSize: 16,
                ),
                const Gap(16),
                ElevatedButton(
                  onPressed: controller.fetchPlans,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: controller.plans.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  final plan = controller.plans[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Plan header
                          Column(
                            children: [
                              if (plan.badge != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: TextSemiBold(
                                    plan.badge!,
                                    fontSize: 12,
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                                const Gap(12),
                              ],
                              TextBold(
                                plan.name.toUpperCase(),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                              const Gap(20),
                              TextSemiBold(
                                plan.description,
                                fontSize: 14,
                                textAlign: TextAlign.center,
                              ),
                              const Gap(20),
                              plan.formattedPrice == 'Free'
                                ? TextBold(
                                    'Free',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  )
                                : RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: plan.nairaSymbol,
                                          style: const TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimaryColor,
                                          ),
                                        ),
                                        TextSpan(
                                          text: plan.priceAmount,
                                          style: const TextStyle(
                                            fontFamily: AppFonts.manRope,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                          const Gap(40),
                          // Plan features
                          Column(
                            children: plan.features
                                .map((feature) => _planCard(feature))
                                .toList(),
                          ),
                          const Gap(40),
                          // Upgrade button
                          Obx(() => BusyButton(
                                width: screenWidth(context) * 0.7,
                                title: "Upgrade",
                                isLoading: controller.isUpgrading,
                                onTap: controller.isUpgrading ? () {} : () {
                                  controller.upgradePlan(plan.id);
                                },
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Page indicator
            Obx(() => _buildPageIndicator()),
            const Gap(20),
          ],
        );
      }),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        controller.plans.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: controller.currentPlanIndex == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: controller.currentPlanIndex == index
                ? AppColors.primaryGreen
                : AppColors.primaryGrey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _planCard(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primaryGrey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppAsset.greenTick),
          const Gap(12),
          Expanded(
            child: TextSemiBold(
              title,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
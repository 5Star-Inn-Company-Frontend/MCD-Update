import 'package:mcd/core/import/imports.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import './spin_win_module_controller.dart';

class SpinWinModulePage extends GetView<SpinWinModuleController> {
  const SpinWinModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PaylonyAppBarTwo(
        title: "Spin & Win",
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        
        // Show error state if no items
        if (controller.spinItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: AppColors.primaryGrey,
                ),
                const Gap(16),
                TextSemiBold(
                  'No spin items available',
                  fontSize: 16,
                  color: AppColors.primaryGrey,
                ),
                const Gap(24),
                BusyButton(
                  title: 'Retry',
                  onTap: controller.fetchSpinData,
                  width: 120,
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome text
              TextBold(
                "Welcome to SPIN & WIN.",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(20),
              // Instructions text
              Text(
                "You only have 5 chance every 5 hours. For every chance there is 3 or more advert videos then you will be able to claim reward if your spin pointer rests on a gift. Kindly use correct recipient details as refund will not be made in case of error.",
                style: const TextStyle(
                  fontFamily: AppFonts.manRope,
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
              const Gap(40),
              // Fortune Wheel
              Center(
                child: SizedBox(
                  height: 450,
                  child: FortuneWheel(
                    selected: controller.selectedStream,
                    items: controller.spinItems
                        .map((item) => FortuneItem(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              style: FortuneItemStyle(
                                color: _getItemColor(controller.spinItems.indexOf(item)),
                                borderColor: Colors.white,
                                borderWidth: 2,
                              ),
                            ))
                        .toList(),
                    animateFirst: false,
                    indicators: const [
                      FortuneIndicator(
                        alignment: Alignment.topCenter,
                        child: TriangleIndicator(
                          color: Colors.amber,
                          width: 30.0,
                          height: 30.0,
                        ),
                      ),
                    ],
                    onAnimationEnd: () {
                      // Animation completed
                    },
                  ),
                ),
              ),
              const Gap(40),
              // Chances remaining
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xffF9F9F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xffE5E5E5)),
                  ),
                  child: TextSemiBold(
                    "Chances Remaining: ${controller.chancesRemaining}/5",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    style: const TextStyle(fontFamily: AppFonts.manRope),
                  ),
                ),
              ),
              const Gap(60),
              // Roll button
              SizedBox(
                width: double.infinity,
                child: Obx(() => BusyButton(
                  title: "Roll",
                  isLoading: controller.isSpinning,
                  onTap: controller.isSpinning || controller.chancesRemaining <= 0 
                      ? () {} 
                      : () => controller.performSpin(),
                )),
              ),
              
              // Info text when no chances left
              if (controller.chancesRemaining == 0) ...[
                const Gap(20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade700),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          'No chances left. Please wait 5 hours for your next spin!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange.shade900,
                            fontFamily: AppFonts.manRope,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }
  
  // Generate alternating purple/green colors for wheel segments
  Color _getItemColor(int index) {
    final colors = [
      const Color(0xFF7E57C2), // Deep purple
      const Color(0xFF4CAF50), // Green (matching primary color)
      const Color(0xFF9575CD), // Medium purple
      const Color(0xFF66BB6A), // Light green
      const Color(0xFFB39DDB), // Light purple
      const Color(0xFF81C784), // Medium green
    ];
    return colors[index % colors.length];
  }
}

import 'package:mcd/core/import/imports.dart';
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
              // Spin wheel placeholder (you can add actual wheel widget here)
              Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xffF3FFF7),
                    border: Border.all(
                      color: AppColors.primaryColor,
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.casino_outlined,
                      size: 100,
                      color: AppColors.primaryColor,
                    ),
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
                  onTap: controller.isSpinning ? () {} : () => controller.performSpin(),
                )),
              ),
            ],
          ),
        );
      }),
    );
  }
}

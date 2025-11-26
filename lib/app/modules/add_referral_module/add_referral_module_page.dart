import 'package:mcd/core/import/imports.dart';
import './add_referral_module_controller.dart';

class AddReferralModulePage extends GetView<AddReferralModuleController> {
  const AddReferralModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Add Referral",
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextSemiBold(
              'Enter Referral Code',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const Gap(8),
            TextSemiBold(
              'Enter the referral code you received from a friend',
              fontSize: 14,
              color: AppColors.primaryGrey,
            ),
            const Gap(24),
            
            // Referral Code Input
            TextFormField(
              controller: controller.referralController,
              decoration: InputDecoration(
                hintText: 'Enter referral code',
                hintStyle: const TextStyle(color: AppColors.primaryGrey),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryGrey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryGreen),
                ),
              ),
            ),
            const Gap(24),
            
            // Submit Button
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.submitReferral,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  disabledBackgroundColor: AppColors.primaryGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? const CircularProgressIndicator(
                        color: AppColors.white,
                      )
                    : TextSemiBold(
                        'Submit',
                        fontSize: 16,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

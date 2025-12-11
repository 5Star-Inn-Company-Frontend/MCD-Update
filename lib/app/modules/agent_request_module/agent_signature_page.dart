import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import './agent_request_module_controller.dart';

class AgentSignaturePage extends GetView<AgentRequestModuleController> {
  const AgentSignaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimaryColor),
          onPressed: () => Get.back(),
        ),
        title: TextSemiBold(
          'Signature',
          fontSize: 18,
          color: AppColors.textPrimaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(20),
            
            // Title
            TextSemiBold(
              'Add your signature to confirm acceptance',
              fontSize: 16,
              textAlign: TextAlign.center,
              color: AppColors.textPrimaryColor,
            ),
            
            const Gap(8),
            
            // Subtitle
            Text(
              'Put your signature in the rectangle below',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.primaryGrey2,
                fontFamily: AppFonts.manRope,
              ),
            ),
            
            const Gap(32),
            
            // Signature Pad
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SfSignaturePad(
                    key: controller.signaturePadKey,
                    backgroundColor: AppColors.white,
                    strokeColor: Colors.black,
                    minimumStrokeWidth: 1.5,
                    maximumStrokeWidth: 3.0,
                  ),
                ),
              ),
            ),
            
            const Gap(24),
            
            // Clear button
            OutlinedButton(
              onPressed: controller.clearSignature,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: TextSemiBold(
                'Clear',
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
            ),
            
            const Gap(16),
            
            // Confirm & Submit button
            Obx(() => BusyButton(
              title: 'Confirm & Submit',
              onTap: controller.submitSignedDocument,
              width: double.infinity,
              disabled: controller.isSubmitting.value,
            )),
            
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

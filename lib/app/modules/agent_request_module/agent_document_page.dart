import 'package:mcd/core/import/imports.dart';
import './agent_request_module_controller.dart';

class AgentDocumentPage extends GetView<AgentRequestModuleController> {
  const AgentDocumentPage({super.key});

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
          'Step 2',
          fontSize: 18,
          color: AppColors.textPrimaryColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            
            // Title
            TextSemiBold(
              'Your Document has been generated successfully, kindly click on read here to preview the document before you sign, then click on sign here to input your signature',
              fontSize: 16,
              textAlign: TextAlign.center,
              color: AppColors.textPrimaryColor,
            ),
            
            // const Gap(12),
            
            // Subtitle
            // Text(
            //   'Kindly click on read here to preview the document before you sign, then click on sign here to input your signature',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: AppColors.primaryGrey2,
            //     fontFamily: AppFonts.manRope,
            //   ),
            // ),
            
            const Spacer(),
            
            // Read here button
            BusyButton(
              title: 'Read here',
              onTap: controller.openDocumentInBrowser,
              width: double.infinity,
            ),
            
            const Gap(36),
            
            // Sign here button
            BusyButton(
              title: 'Sign here',
              onTap: () => Get.toNamed(Routes.AGENT_SIGNATURE),
              width: double.infinity,
            ),
            
            const Gap(40),
          ],
        ),
      ),
    );
  }
}

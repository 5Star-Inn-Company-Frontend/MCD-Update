import '../../../core/import/imports.dart';
import './number_verification_module_controller.dart';

class NumberVerificationModulePage
    extends GetView<NumberVerificationModuleController> {
  const NumberVerificationModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Verify Phone Number",
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(30),
              TextSemiBold(
                "Enter Phone Number",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const Gap(8),
              TextSemiBold(
                "Please enter the phone number you want to verify for this transaction.",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const Gap(20),
              TextFormField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  fontFamily: AppFonts.manRope,
                ),
                decoration: textInputDecoration.copyWith(
                  hintText: "Enter phone number",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: AppFonts.manRope,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.content_paste,
                            color: AppColors.primaryColor),
                        onPressed: controller.pasteFromClipboard,
                        tooltip: 'Paste',
                      ),
                      IconButton(
                        icon: const Icon(Icons.contacts,
                            color: AppColors.primaryColor),
                        onPressed: controller.pickContact,
                        tooltip: 'Select Contact',
                      ),
                      // IconButton(
                      //   icon: Image.asset('assets/icons/contact-person-icon.png', width: 24, height: 24),
                      //   onPressed: controller.pickContact,
                      // ),
                    ],
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (value.length < 11) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const Gap(40),
              Obx(() => BusyButton(
                    title: "Verify Number",
                    onTap: controller.verifyNumber,
                    isLoading: controller.isLoading.value,
                  )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primaryColor),
                    Gap(10),
                    Expanded(
                      child: Text(
                        "We'll verify your number before proceeding with the transaction.",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 13,
                          fontFamily: AppFonts.manRope,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }
}

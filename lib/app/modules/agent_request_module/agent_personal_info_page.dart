import 'package:mcd/core/import/imports.dart';
import './agent_request_module_controller.dart';

class AgentPersonalInfoPage extends GetView<AgentRequestModuleController> {
  const AgentPersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const PaylonyAppBarTwo(
        title: 'Personal Information',
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: controller.personalInfoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Name
              TextSemiBold(
                'First Name',
                fontSize: 14,
                color: AppColors.textPrimaryColor,
              ),
              const Gap(8),
              TextFormField(
                controller: controller.firstNameController,
                style: TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontFamily: AppFonts.manRope,
                ),
                decoration: InputDecoration(
                  hintText: 'Akanji Joseph',
                  hintStyle: const TextStyle(
                    color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope
                  ),
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
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const Gap(20),

              // Business Name
              TextSemiBold(
                'Business Name',
                fontSize: 14,
                color: AppColors.textPrimaryColor,
              ),
              const Gap(8),
              TextFormField(
                controller: controller.businessNameController,
                style: TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontFamily: AppFonts.manRope,
                ),
                decoration: InputDecoration(
                  hintText: 'Joe accessories',
                  hintStyle: const TextStyle(
                    color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope
                  ),
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
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Business name is required';
                  }
                  return null;
                },
              ),
              const Gap(20),

              // Date of Birth
              TextSemiBold(
                'Date of birth /DD/MM/YY',
                fontSize: 14,
                color: AppColors.textPrimaryColor,
              ),
              const Gap(8),
              TextFormField(
                controller: controller.dobController,
                style: TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontFamily: AppFonts.manRope,
                ),
                decoration: InputDecoration(
                  hintText: '00/00/00',
                  hintStyle: const TextStyle(
                    color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope
                  ),
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
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Date of birth is required';
                  }
                  return null;
                },
              ),
              const Gap(20),

              // Phone Number
              TextSemiBold(
                'Phone Number',
                fontSize: 14,
                color: AppColors.textPrimaryColor,
              ),
              const Gap(8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryGrey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        TextSemiBold('+234', fontSize: 14),
                        const Gap(4),
                        const Icon(Icons.keyboard_arrow_down, size: 20),
                      ],
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: TextFormField(
                      controller: controller.phoneNumberController,
                      style: TextStyle(
                        color: AppColors.textPrimaryColor,
                        fontFamily: AppFonts.manRope,
                      ),
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(
                          color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope
                        ),
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
                          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const Gap(20),

              // Address
              TextSemiBold(
                'Address',
                fontSize: 14,
                color: AppColors.textPrimaryColor,
              ),
              const Gap(8),
              TextFormField(
                controller: controller.addressController,
                maxLines: 3,
                style: TextStyle(
                  color: AppColors.textPrimaryColor,
                  fontFamily: AppFonts.manRope,
                ),
                decoration: InputDecoration(
                  hintText: 'NO / Street Address / State / Country',
                  hintStyle: const TextStyle(
                    color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope
                  ),
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
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const Gap(40),

              // Submit Button
              Center(
                child: Obx(() => BusyButton(
                  title: 'Submit',
                  onTap: controller.submitAgentRequest,
                  width: screenWidth(context) * 0.8,
                  disabled: !controller.isPersonalInfoFormValid.value || controller.isSubmitting.value,
                )),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:mcd/app/modules/cable_module/cable_module_controller.dart';
import 'package:mcd/app/modules/cable_module/model/cable_package_model.dart';
import 'package:mcd/app/modules/cable_module/model/cable_provider_model.dart';
import 'package:mcd/core/import/imports.dart';

class CableModulePage extends GetView<CableModuleController> {
  const CableModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Cable Tv",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(child: TextSemiBold("History")),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProviderDropdown(),
                      const Gap(25),
                      _buildSmartCardInput(),
                      const Gap(20),
                      _buildMonthTabs(),
                      const Gap(20),
                      _buildPlanContent(context),
                      const Gap(25),
                      TextSemiBold("Select Package"),
                      const Gap(14),

                      // Package selection
                      Obx(() {
                        if (controller.isLoadingPackages.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (controller.cablePackages.isEmpty) {
                          return const Center(child: Text("No packages available"));
                        }

                        return Column(
                          children: controller.cablePackages.map((package) {
                            return Obx(() => RadioListTile<CablePackage>(
                              title: Text(package.name),
                              subtitle: Text("₦${package.amount}"),
                              value: package,
                              groupValue: controller.selectedPackage.value,
                              onChanged: (value) => controller.onPackageSelected(value),
                              activeColor: AppColors.primaryColor,
                            ));
                          }).toList(),
                        );
                      }),

                      const Spacer(),
                      Obx(() => BusyButton(
                        title: "Pay",
                        isLoading: controller.isPaying.value,
                        onTap: controller.pay,
                      )),
                      const Gap(30),
                      SizedBox(width: double.infinity, child: Image.asset(AppAsset.banner)),
                      const Gap(20)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProviderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primaryGrey)),
      ),
      child: Obx(() {
        if (controller.isLoadingProviders.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }
        return DropdownButtonHideUnderline(
        child: DropdownButton<CableProvider>(
          isExpanded: true,
          value: controller.selectedProvider.value,
          items: controller.cableProviders.map((provider) {
            final imageUrl = controller.providerImages[provider.name] ?? controller.providerImages['DEFAULT']!;
            return DropdownMenuItem<CableProvider>(
              value: provider,
              child: Row(children: [
                Image.asset(imageUrl, width: 40),
                const Gap(10),
                Text(provider.name),
              ]),
            );
          }).toList(),
          onChanged: (value) => controller.onProviderSelected(value),
        ),
      );}),
    );
  }

  Widget _buildSmartCardInput() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffF1F1F1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Smart card Number'),
          const Gap(4),
          TextFormField(
            controller: controller.smartCardController,
            validator: (value) {
              if (value == null || value.isEmpty) return "Card No needed";
              if (value.length < 5) return "Card no not valid";
              return null;
            },
            decoration: const InputDecoration(
                suffix: Icon(Icons.cancel_rounded), hintText: '012345678'),
          ),
          Obx(() {
            if (controller.isValidating.value) {
              return const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor),
                    ),
                    Gap(8),
                    Text("Validating...", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            }
            if (controller.validatedCustomerName.value != null) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const Gap(4),
                    Expanded(
                      child: Text(
                        controller.validatedCustomerName.value!,
                        style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildMonthTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryGrey.withOpacity(0.4)),
        ),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: controller.tabBarItems.map((item) {
                bool isSelected = item == controller.selectedTab.value;
                return TouchableOpacity(
                  onTap: () => controller.onTabSelected(item),
                  child: Container(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        right: item == controller.tabBarItems.last
                            ? BorderSide.none
                            : const BorderSide(color: AppColors.primaryGrey),
                      ),
                    ),
                    child: TextSemiBold(
                      item,
                      color: isSelected ? AppColors.primaryColor : AppColors.textPrimaryColor,
                    ),
                  ),
                );
              }).toList(),
            )),
      ),
    );
  }

  Widget _buildPlanContent(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPackages.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return SizedBox(
        height: screenHeight(context) * 0.30,
        // Assuming CableMonthPlanWidget is adapted to take a list of packages
        // child: CableMonthPlanWidget(packages: controller.cablePackages),
      );
    });
  }
}
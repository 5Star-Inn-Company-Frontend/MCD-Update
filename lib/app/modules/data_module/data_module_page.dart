import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gap/gap.dart';
import 'package:mcd/app/modules/data_module/network_provider.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/widgets/touchableOpacity.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/core/constants/textField.dart';
import 'package:mcd/core/utils/ui_helpers.dart';
import './data_module_controller.dart';

class DataModulePage extends GetView<DataModuleController> {
  const DataModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Data Bundle",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              child: TextSemiBold("History", fontWeight: FontWeight.w700, fontSize: 16),
            ),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight - kToolbarHeight
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNetworkSelector(),
                  const Gap(30),
                  _buildBonusSection(),
                  const Gap(20),
                  _buildPlanContent(context),
                  const Spacer(),
                  Obx(() => BusyButton(
                      title: "Buy Plan",
                      isLoading: controller.isPaying.value,
                      onTap: controller.pay,
                  )),
                  const Gap(25),
                  SizedBox(width: double.infinity, child: Image.asset(AppAsset.banner)),
                  const Gap(20)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNetworkSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.primaryGrey)),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton2<NetworkProvider>(
                    isExpanded: true,
                    iconStyleData: const IconStyleData(
                        icon: Icon(Icons.keyboard_arrow_down_rounded, size: 30)),
                    items: controller.networkProviders
                        .map((provider) => DropdownMenuItem<NetworkProvider>(
                              value: provider,
                              child: Image.asset(provider.imageAsset, width: 50),
                            ))
                        .toList(),
                    value: controller.selectedNetworkProvider.value,
                    onChanged: (value) => controller.onNetworkSelected(value),
                  ),
                )),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 3,
            height: 30,
            decoration: const BoxDecoration(color: AppColors.primaryGrey),
          ),
          Flexible(
            flex: 3,
            child: TextFormField(
              controller: controller.phoneController,
              decoration: textInputDecoration.copyWith(
                  filled: false,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: const Icon(Icons.person_2_outlined)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF3FFF7),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Bonus ₦10", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(5)),
            child: TextSemiBold("Claim", color: AppColors.white),
          )
        ],
      ),
    );
  }
  
  Widget _buildPlanContent(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.value != null) {
        return Center(child: Text(controller.errorMessage.value!));
      }
      return Column(
        children: [
          _buildCategoryTabs(),
          const Gap(20),
          SizedBox(
            height: screenHeight(context) * 0.30,
            child: _buildPlanGrid()
          ),
        ],
      );
    });
  }

  Widget _buildCategoryTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: double.infinity,
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
  
  Widget _buildPlanGrid() {
    return Obx(() {
      if (controller.filteredDataPlans.isEmpty) {
        return const Center(child: Text("No plans available for this category."));
      }
      return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            childAspectRatio: 1.8,
          ),
          itemCount: controller.filteredDataPlans.length,
          itemBuilder: (context, index) {
            final plan = controller.filteredDataPlans[index];
            return Obx(() {
              final isSelected = controller.selectedPlan.value?.id == plan.id;
              return TouchableOpacity(
                onTap: () => controller.onPlanSelected(plan),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? AppColors.primaryColor : AppColors.primaryGrey.withOpacity(0.4),
                      width: isSelected ? 2.0 : 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSemiBold(plan.name, fontSize: 14, maxLines: 2),
                      TextSemiBold('₦${plan.price}', color: AppColors.primaryColor, fontSize: 16),
                    ],
                  ),
                ),
              );
            });
          },
        );
    });
  }
}
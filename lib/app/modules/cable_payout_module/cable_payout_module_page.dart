import 'package:mcd/app/modules/cable_module/cable_module_controller.dart';
import 'package:mcd/app/modules/cable_payout_module/cable_payout_module_controller.dart';
import 'package:mcd/core/import/imports.dart';

class CablePayoutPage extends GetView<CablePayoutController> {
  const CablePayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(title: "Payout"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(30),
            Image.asset(
              Get.find<CableModuleController>().providerImages[controller.provider.name] ?? '',
              height: 41, width: 41
            ),
            Text(
              controller.provider.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const Gap(30),
            _buildDetailsCard(),
            const Gap(20),
            _buildBouquetCard(),
            const Gap(20),
            
            // Show action buttons or payment flow based on selection
            Obx(() {
              if (!controller.isRenewalMode.value && !controller.showPackageSelection.value) {
                return _buildActionButtons();
              } else if (controller.isRenewalMode.value) {
                return Column(
                  children: [
                    _buildPaymentMethod(),
                    const Gap(40),
                    BusyButton(
                      title: "Confirm & Pay",
                      onTap: controller.confirmAndPay,
                      isLoading: controller.isPaying.value,
                    ),
                  ],
                );
              } else if (controller.showPackageSelection.value) {
                return Column(
                  children: [
                    _buildMonthTabs(),
                    const Gap(20),
                    _buildPackageSelection(),
                    const Gap(40),
                    BusyButton(
                      title: "Confirm & Pay",
                      onTap: controller.confirmAndPay,
                      isLoading: controller.isPaying.value,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffE0E0E0))),
      child: Column(
        children: [
          _rowCard('Account Name', controller.customerName),
          const Gap(15),
          _rowCard('Biller Name', controller.provider.name),
          const Gap(15),
          _rowCard('Smartcard Number', controller.smartCardNumber),
        ],
      ),
    );
  }

  Widget _buildBouquetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xffE0E0E0))),
      child: Obx(() => Column(
        children: [
          _rowCard('Current Bouquet', controller.currentBouquet.value),
          const Gap(15),
          _rowCard('Bouquet Price', '₦${controller.currentBouquetPrice.value}'),
          const Gap(15),
          _rowCard('Due Date', controller.currentDueDate.value),
          const Gap(15),
          _rowCard('Status', controller.accountStatus.value),
        ],
      )),
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

  Widget _buildPackageSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextSemiBold('Select Package', fontSize: 13),
        // const Gap(9),
        Obx(() {
          if (controller.isLoadingPackages.value) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (controller.filteredPackages.isEmpty) {
            return const Center(child: Text("No packages available for selected duration"));
          }
          
          return SizedBox(
            height: 400,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.85,
              ),
              itemCount: controller.filteredPackages.length,
              itemBuilder: (context, index) {
                final package = controller.filteredPackages[index];
                return Obx(() {
                  final isSelected = controller.selectedPackage.value == package;
                  return GestureDetector(
                    onTap: () => controller.onPackageSelected(package),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        // borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.primaryColor : Colors.black,
                            ),
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(8),
                          Text(
                            '₦${package.amount}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.primaryColor : Colors.black87,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            'N3 Cashback',
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? AppColors.primaryColor : Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSemiBold('Payment Method', fontSize: 13),
        const Gap(9),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xffE0E0E0))),
          child: Obx(()=> Column(
            children: [
              RadioListTile(
                title: const Text('Wallet Balance (₦0.00)'),
                value: 1,
                groupValue: controller.selectedPaymentMethod.value,
                onChanged: controller.selectPaymentMethod,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
              RadioListTile(
                title: const Text('Mega Bonus (₦0.00)'),
                value: 2,
                groupValue: controller.selectedPaymentMethod.value,
                onChanged: controller.selectPaymentMethod,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            ],
          )),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.onRenewTapped(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Renew',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const Gap(15),
        Expanded(
          child: ElevatedButton(
            onPressed: () => controller.onNewBouquetTapped(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'New Bouquet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowCard(String title, String subtitle) {
    return Row(
      children: [
        TextSemiBold(title, fontSize: 15),
        const Spacer(),
        Text(subtitle, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
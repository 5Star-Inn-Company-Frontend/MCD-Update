
import 'package:mcd/app/modules/betting_module/model/betting_provider_model.dart';
import 'package:mcd/core/import/imports.dart';
import './betting_module_controller.dart';

class BettingModulePage extends GetView<BettingModuleController> {
  const BettingModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Betting",
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              child: TextSemiBold("History", fontWeight: FontWeight.w700, fontSize: 16),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(backgroundColor: AppColors.primaryColor, color: AppColors.primaryColor,));
        }
        if (controller.errorMessage.value != null) {
          return Center(child: Text(controller.errorMessage.value!));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.primaryGrey)),
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: _buildProviderDropdown(),
                        ),
                      ],
                    ),
                  ),
                  const Gap(30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xffE0E0E0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "User ID",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, fontFamily: AppFonts.manRope),
                        ),
                        TextFormField(controller: controller.userIdController),

                        Obx(() {
                          if (controller.isPaying.value) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text("Validating...", style: TextStyle(color: Colors.grey)),
                            );
                          }
                          if (controller.validatedUserName.value != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                controller.validatedUserName.value!,
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ],
                    ),
                  ),
                  const Gap(25),
                  TextSemiBold("Deposit Amount"),
                  const Gap(14),
                  Container(
                    height: screenHeight(context) * 0.27,
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xffF1F1F1))),
                    child: Column(
                      children: [
                        Flexible(
                          child: GridView(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 150,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 3 / 1.3,
                            ),
                            children: [
                              _amountCard('₦500.00'),
                              _amountCard('₦1000.00'),
                              _amountCard('₦2000.00'),
                              _amountCard('₦5000.00'),
                              _amountCard('₦10000.00'),
                              _amountCard('₦20000.00'),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Text("₦", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                            const Gap(8),
                            Flexible(
                              child: TextFormField(
                                controller: controller.amountController,
                                decoration: const InputDecoration(
                                  hintText: '500.00 - 50,000.00',
                                  hintStyle: TextStyle(color: AppColors.primaryGrey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  BusyButton(
                    title: "Pay",
                    disabled: controller.isPaying.value,
                    onTap: controller.pay,
                  ),
                  const Gap(30),
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

  Widget _buildProviderDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<BettingProvider>(
        isExpanded: true,
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        ),
        items: controller.bettingProviders
            .map((provider) => DropdownMenuItem<BettingProvider>(
                  value: provider,
                  child: Image.asset(
                    controller.providerImages[provider.name] ?? controller.providerImages['DEFAULT']!,
                    width: 50,
                  ),
                ))
            .toList(),
        value: controller.selectedProvider.value,
        onChanged: (value) => controller.onProviderSelected(value),
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 110,
        ),
        menuItemStyleData: const MenuItemStyleData(height: 60, overlayColor: WidgetStatePropertyAll(Colors.white)),
      ),
    );
  }

  Widget _amountCard(String amount) {
    return InkWell(
      onTap: () => controller.onAmountSelected(amount),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xffF1F1F1)),
        ),
        child: Center(
          child: Text(
            amount,
            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
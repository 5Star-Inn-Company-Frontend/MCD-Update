import 'package:mcd/app/modules/airtime_module/model/airtime_provider_model.dart';
import '../../../core/import/imports.dart';
import './airtime_module_controller.dart';

class AirtimeModulePage extends GetView<AirtimeModuleController> {
  const AirtimeModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Airtime",
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
      body:  LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.primaryGrey)),
                        ),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 1,
                              child: Obx(() { 
                                if (controller.isLoading) {
                                  return const SizedBox(
                                    height: 40,
                                    child: Center(child: CircularProgressIndicator(strokeWidth: 2,color: AppColors.primaryColor,)),
                                  );
                                }

                                if (controller.errorMessage != null) {
                                  return SizedBox(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        "Failed to load",
                                        style: const TextStyle(color: Colors.red, fontSize: 12),
                                      ),
                                    ),
                                  );
                                }
                              
                                return DropdownButtonHideUnderline(
                                child: DropdownButton2<AirtimeProvider>(
                                  isExpanded: true,
                                  iconStyleData: const IconStyleData(
                                      icon: Icon(Icons.keyboard_arrow_down_rounded, size: 30)),
                                  items: controller.airtimeProviders
                                    .map((provider) => DropdownMenuItem<AirtimeProvider>(
                                        value: provider,
                                        child: Image.asset(
                                          controller.networkImages[provider.network] ?? AppAsset.mtn, // Fallback image
                                          width: 50,
                                        ),
                                      ))
                                    .toList(),
                                  value: controller.selectedProvider.value,
                                  onChanged: (value) => controller.onProviderSelected(value),
                                  buttonStyleData: const ButtonStyleData(
                                      padding: EdgeInsets.symmetric(horizontal: 16),
                                      height: 40,
                                      width: 140),
                                  menuItemStyleData: const MenuItemStyleData(height: 40),
                                ),
                              );}),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 3,
                              height: 30,
                              decoration: const BoxDecoration(color: AppColors.primaryGrey),
                            ),
                            Flexible(
                              flex: 3,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) return ("Pls input phone number");
                                  if (value.length != 11) return ("Pls Input valid number");
                                  return null;
                                },
                                decoration: textInputDecoration.copyWith(
                                    filled: false,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    suffixIcon: const Icon(Icons.person_2_outlined)),
                                controller: controller.phoneController,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Gap(30),

                      //bonus coontainer
                      Container(
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
                      ),
                      
                      const Gap(25),
                      TextSemiBold("Select Amount"),
                      const Gap(14),
                      
                      // amounts container
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
                                  _amountCard('50'),
                                  _amountCard('100'),
                                  _amountCard('200'),
                                  _amountCard('500'),
                                  _amountCard('1000'),
                                  _amountCard('2000'),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return ("Pls input amount");
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: '500.00 - 50,000.00',
                                      hintStyle: TextStyle(color: AppColors.primaryGrey),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const Gap(40),
                      BusyButton(title: "Pay", onTap: controller.pay, isLoading: controller.isPaying),
                      const Gap(30),
                      SizedBox(width: double.infinity, child: Image.asset(AppAsset.banner)),
                      const Gap(20)
                    ],
                  ),
                ),
              ),
            ),
          );
      }),
    );
  }

  Widget _amountCard(String amount) {
    return TouchableOpacity(
      onTap: () => controller.onAmountSelected(amount),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xffF1F1F1))),
        child: Center(
          child: Text('₦$amount', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
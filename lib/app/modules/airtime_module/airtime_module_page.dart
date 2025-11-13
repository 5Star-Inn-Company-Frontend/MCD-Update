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
              onTap: () => Get.toNamed(Routes.HISTORY_SCREEN),
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
                                style: TextStyle(fontFamily: AppFonts.manRope,),
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
                            const Text("Bonus ₦10", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: AppFonts.manRope)),
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
                                    style: TextStyle(fontFamily: AppFonts.manRope,),
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
                      
                      const Gap(24),
                      // Payment Method Selection
                      Obx(() => InkWell(
                        onTap: () => _showPaymentMethodBottomSheet(context),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primaryGrey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Method',
                                    style: const TextStyle(
                                      fontFamily: AppFonts.manRope,
                                      fontSize: 12,
                                      color: AppColors.primaryGrey2,
                                    ),
                                  ),
                                  const Gap(4),
                                  Text(
                                    _getPaymentMethodLabel(controller.selectedPaymentMethod.value),
                                    style: const TextStyle(
                                      fontFamily: AppFonts.manRope,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryGrey2),
                            ],
                          ),
                        ),
                      )),
                      
                      const Gap(40),
                      Obx(() => BusyButton(
                        title: "Pay",
                        onTap: controller.pay,
                        isLoading: controller.isPaying,
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

  String _getPaymentMethodLabel(String method) {
    switch (method) {
      case 'wallet':
        return 'Wallet Balance';
      case 'paystack':
        return 'Paystack';
      case 'general_market':
        return 'General Market';
      case 'mega_bonus':
        return 'Mega Bonus';
      default:
        return 'Wallet Balance';
    }
  }

  void _showPaymentMethodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBold(
                  'Select Payment Method',
                  fontSize: 18,
                  style: const TextStyle(fontFamily: AppFonts.manRope),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Gap(20),
            _paymentMethodTile('wallet', 'Wallet Balance', context),
            const Gap(12),
            _paymentMethodTile('paystack', 'Paystack', context),
            const Gap(12),
            _paymentMethodTile('general_market', 'General Market', context),
            const Gap(12),
            _paymentMethodTile('mega_bonus', 'Mega Bonus', context),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodTile(String value, String label, BuildContext context) {
    return Obx(() => InkWell(
      onTap: () {
        controller.setPaymentMethod(value);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.selectedPaymentMethod.value == value
                ? AppColors.primaryColor
                : AppColors.primaryGrey,
            width: controller.selectedPaymentMethod.value == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: controller.selectedPaymentMethod.value == value
              ? AppColors.primaryColor.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.manRope,
                fontSize: 16,
                fontWeight: controller.selectedPaymentMethod.value == value
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
            if (controller.selectedPaymentMethod.value == value)
              const Icon(Icons.check_circle, color: AppColors.primaryColor),
          ],
        ),
      ),
    ));
  }
}
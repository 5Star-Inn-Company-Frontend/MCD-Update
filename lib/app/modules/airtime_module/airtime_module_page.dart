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
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Gap(15),
                      
                      // Animated toggle between Single and Multiple Airtime
                      Obx(() => Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              left: controller.isSingleAirtime.value ? 0 : MediaQuery.of(context).size.width * 0.5 - 15,
                              right: controller.isSingleAirtime.value ? MediaQuery.of(context).size.width * 0.5 - 15 : 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.isSingleAirtime.value = true;
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 300),
                                          style: TextStyle(
                                            fontFamily: AppFonts.manRope,
                                            fontSize: 14,
                                            fontWeight: controller.isSingleAirtime.value ? FontWeight.w600 : FontWeight.w500,
                                            color: controller.isSingleAirtime.value ? AppColors.white : AppColors.primaryGrey2,
                                          ),
                                          child: const Text('Single Airtime'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.isSingleAirtime.value = false;
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: AnimatedDefaultTextStyle(
                                          duration: const Duration(milliseconds: 300),
                                          style: TextStyle(
                                            fontFamily: AppFonts.manRope,
                                            fontSize: 14,
                                            fontWeight: !controller.isSingleAirtime.value ? FontWeight.w600 : FontWeight.w500,
                                            color: !controller.isSingleAirtime.value ? AppColors.white : AppColors.primaryGrey2,
                                          ),
                                          child: const Text('Multiple Airtime'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                      
                      const Gap(25),
                      
                      // Animated content switcher
                      Obx(() => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: controller.isSingleAirtime.value
                            ? _buildSingleAirtimeForm(context)
                            : _buildMultipleAirtimeForm(context),
                      )),
                ],
              ),
            ),
          );
      }),
    );
  }

  Widget _buildSingleAirtimeForm(BuildContext context) {
    return Column(
      key: const ValueKey('single'),
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
                            controller.networkImages[provider.network] ?? AppAsset.mtn,
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

        //bonus container
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
    );
  }

  Widget _buildMultipleAirtimeForm(BuildContext context) {
    return Column(
      key: const ValueKey('multiple'),
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
                            controller.networkImages[provider.network] ?? AppAsset.mtn,
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
                  style: TextStyle(fontFamily: AppFonts.manRope,),
                  keyboardType: TextInputType.phone,
                  decoration: textInputDecoration.copyWith(
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      hintText: '08156995030',
                      suffixIcon: const Icon(Icons.person_2_outlined)),
                  controller: controller.phoneController,
                ),
              ),
            ],
          ),
        ),

        const Gap(25),
        TextSemiBold("Select Amount"),
        const Gap(14),
        
        // amounts container
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xffF1F1F1))),
          child: Column(
            children: [
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.5,
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
              const Gap(10),
              Row(
                children: [
                  const Text("₦", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                  const Gap(8),
                  Flexible(
                    child: TextFormField(
                      controller: controller.amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontFamily: AppFonts.manRope,),
                      decoration: const InputDecoration(
                        hintText: 'Custom amount',
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
        
        // Add button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: controller.addToMultipleList,
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
            label: TextSemiBold('Add', color: AppColors.primaryColor),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              side: const BorderSide(color: AppColors.primaryColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        
        const Gap(20),
        
        // Multiple airtime list
        Obx(() {
          if (controller.multipleAirtimeList.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.list_alt, size: 40, color: AppColors.primaryGrey2),
                    const Gap(10),
                    Text(
                      'You can add upto 5 number',
                      style: TextStyle(
                        fontFamily: AppFonts.manRope,
                        color: AppColors.primaryGrey2,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextSemiBold('Added Numbers (${controller.multipleAirtimeList.length})'),
                  TextSemiBold(
                    '#${controller.multipleAirtimeList.fold<double>(0, (sum, item) => sum + double.parse(item['amount'])).toStringAsFixed(0)}',
                    fontSize: 18,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
              const Gap(15),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.multipleAirtimeList.length,
                separatorBuilder: (_, __) => const Gap(10),
                itemBuilder: (context, index) {
                  final item = controller.multipleAirtimeList[index];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          item['networkImage'],
                          width: 35,
                          height: 35,
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['phoneNumber'],
                                style: const TextStyle(
                                  fontFamily: AppFonts.manRope,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '#${item['amount']}',
                                style: TextStyle(
                                  fontFamily: AppFonts.manRope,
                                  fontSize: 13,
                                  color: AppColors.primaryGrey2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => controller.removeFromMultipleList(index),
                          icon: const Icon(Icons.close, color: Colors.red, size: 20),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }),
        
        const Gap(30),
        Obx(() => BusyButton(
          title: "Pay",
          onTap: controller.payMultiple,
          isLoading: controller.isPaying,
        )),
        const Gap(20),
      ],
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
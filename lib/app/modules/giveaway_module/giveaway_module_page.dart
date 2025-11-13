import 'package:mcd/core/import/imports.dart';
import './giveaway_module_controller.dart';

class GiveawayModulePage extends GetView<GiveawayModuleController> {
  const GiveawayModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: "Giveaway",
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => Get.toNamed(Routes.HISTORY_SCREEN),
              child: TextSemiBold(
                "History",
                fontWeight: FontWeight.w700,
                fontSize: 18,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
            ),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }
        
        return RefreshIndicator(
          color: AppColors.primaryColor,
          backgroundColor: AppColors.white,
          onRefresh: controller.fetchGiveaways,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.background,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextSemiBold(
                              "You have ${controller.myGiveawayCount} giveaways",
                              style: const TextStyle(fontFamily: AppFonts.manRope),
                            ),
                            InkWell(
                              onTap: () => _showCreateGiveawayDialog(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: TextSemiBold(
                                  "Create giveaway",
                                  color: AppColors.white,
                                  style: const TextStyle(fontFamily: AppFonts.manRope),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Gap(30),
                      TextSemiBold(
                        "All Giveaways",
                        style: const TextStyle(fontFamily: AppFonts.manRope),
                      ),
                      const Gap(19),
                    ],
                  ),
                ),
              ),
              controller.giveaways.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "No giveaways available",
                          style: const TextStyle(
                            fontFamily: AppFonts.manRope,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 26.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 3 / 2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final giveaway = controller.giveaways[index];
                            return _boxCard(
                              giveaway.userName,
                              '${giveaway.amount} x ${giveaway.quantity}',
                              () => _showGiveawayDetail(context, giveaway.id),
                              giveaway.image,
                            );
                          },
                          childCount: controller.giveaways.length,
                        ),
                      ),
                    ),
            ],
          ),
        );
      }),
    );
  }

  Widget _boxCard(String title, String text, VoidCallback onTap, String imageUrl) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
            color: const Color(0xffF3FFF7),
            border: Border.all(color: const Color(0xffF0F0F0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (imageUrl.isNotEmpty)
              Expanded(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                ),
              ),
            const Gap(8),
            TextSemiBold(
              title,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              style: const TextStyle(fontFamily: AppFonts.manRope),
            ),
            Text(
              text,
              style: const TextStyle(
                  fontFamily: AppFonts.manRope,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
              textAlign: TextAlign.center,
            ),
            BusyButton(
              title: "View",
              height: 40,
              onTap: onTap,
            )
          ],
        ),
      ),
    );
  }

  void _showCreateGiveawayDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBold(
                "Create Giveaway",
                fontSize: 20,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(20),
              // Amount field
              TextFormField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(16),
              // Quantity field
              TextFormField(
                controller: controller.quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(16),
              // Description field
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(16),
              // Image picker
              Obx(() => Column(
                    children: [
                      if (controller.selectedImage != null)
                        Image.file(
                          controller.selectedImage!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ElevatedButton.icon(
                        onPressed: controller.pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Pick Image'),
                      ),
                    ],
                  )),
              const Gap(16),
              // Type code selection
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedTypeCode,
                    decoration: const InputDecoration(
                      labelText: 'Network',
                      border: OutlineInputBorder(),
                    ),
                    items: ['mtn', 'glo', 'airtel', '9mobile']
                        .map((code) => DropdownMenuItem(
                              value: code,
                              child: Text(
                                code.toUpperCase(),
                                style: const TextStyle(fontFamily: AppFonts.manRope),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) controller.setTypeCode(value);
                    },
                  )),
              const Gap(16),
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
              const Gap(24),
              Obx(() => BusyButton(
                    title: "Create Giveaway",
                    isLoading: controller.isCreating,
                    onTap: () async {
                      final success = await controller.createGiveaway();
                      if (success) Get.back();
                    },
                  )),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showGiveawayDetail(BuildContext context, int giveawayId) async {
    final detail = await controller.fetchGiveawayDetail(giveawayId);
    if (detail == null) return;

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBold(
                "Giveaway Details",
                fontSize: 20,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(16),
              if (detail.giveaway.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    detail.giveaway.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                  ),
                ),
              const Gap(16),
              _detailRow('Amount', detail.giveaway.amount),
              _detailRow('Quantity', detail.giveaway.quantity.toString()),
              _detailRow('Type', detail.giveaway.type),
              _detailRow('Description', detail.giveaway.description),
              _detailRow('Claimed', '${detail.requesters.length}/${detail.giveaway.quantity}'),
              const Gap(16),
              if (!detail.completed)
                Column(
                  children: [
                    TextFormField(
                      controller: controller.receiverController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        hintStyle: TextStyle(color: AppColors.primaryGrey2, fontFamily: AppFonts.manRope),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primaryColor),
                        ),
                      ),
                      style: const TextStyle(fontFamily: AppFonts.manRope),
                    ),
                    const Gap(16),
                    BusyButton(
                      title: "Claim Giveaway",
                      onTap: () async {
                        final success = await controller.claimGiveaway(
                          giveawayId,
                          controller.receiverController.text,
                        );
                        if (success) {
                          controller.receiverController.clear();
                          Get.back();
                        }
                      },
                    ),
                  ],
                )
              else
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'This giveaway has been fully claimed',
                    style: TextStyle(
                      fontFamily: AppFonts.manRope,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextSemiBold(
            label,
            style: const TextStyle(fontFamily: AppFonts.manRope),
          ),
          Text(
            value,
            style: const TextStyle(fontFamily: AppFonts.manRope),
          ),
        ],
      ),
    );
  }

  // Helper method to get payment method label
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

  // Show payment method selection bottom sheet
  void _showPaymentMethodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
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
            const Gap(16),
            Obx(() => Column(
              children: [
                _paymentMethodTile(
                  title: 'Wallet Balance',
                  value: 'wallet',
                  selectedValue: controller.selectedPaymentMethod.value,
                  onTap: () {
                    controller.setPaymentMethod('wallet');
                    Navigator.pop(context);
                  },
                ),
                _paymentMethodTile(
                  title: 'Paystack',
                  value: 'paystack',
                  selectedValue: controller.selectedPaymentMethod.value,
                  onTap: () {
                    controller.setPaymentMethod('paystack');
                    Navigator.pop(context);
                  },
                ),
                _paymentMethodTile(
                  title: 'General Market',
                  value: 'general_market',
                  selectedValue: controller.selectedPaymentMethod.value,
                  onTap: () {
                    controller.setPaymentMethod('general_market');
                    Navigator.pop(context);
                  },
                ),
                _paymentMethodTile(
                  title: 'Mega Bonus',
                  value: 'mega_bonus',
                  selectedValue: controller.selectedPaymentMethod.value,
                  onTap: () {
                    controller.setPaymentMethod('mega_bonus');
                    Navigator.pop(context);
                  },
                ),
              ],
            )),
            const Gap(20),
          ],
        ),
      ),
    );
  }

  // Payment method tile widget
  Widget _paymentMethodTile({
    required String title,
    required String value,
    required String selectedValue,
    required VoidCallback onTap,
  }) {
    final isSelected = value == selectedValue;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.primaryGrey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.manRope,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primaryColor : Colors.black87,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
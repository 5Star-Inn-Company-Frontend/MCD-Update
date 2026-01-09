import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/import/imports.dart';
import 'package:mcd/core/utils/amount_formatter.dart';
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
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 1,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final giveaway = controller.giveaways[index];
                            return _boxCard(
                              giveaway.userName,
                              '${giveaway.amount} • ${giveaway.quantity} claims',
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE5E5E5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                imageUrl,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 80,
                  color: const Color(0xffF3FFF7),
                  child: const Icon(Icons.image, color: AppColors.primaryGrey2),
                ),
              ),
            ),
          const Gap(8),
          TextSemiBold(
            title,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            style: const TextStyle(fontFamily: AppFonts.manRope),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(4),
          Text(
            text,
            style: const TextStyle(
              fontFamily: AppFonts.manRope,
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: AppColors.primaryGrey2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: TextSemiBold(
                  "Claim",
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateGiveawayDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBold(
                "Create Giveaway",
                fontSize: 22,
                fontWeight: FontWeight.w700,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(24),
              // Short Note / Description field
              TextSemiBold(
                'Short Note',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(8),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter a brief description',
                  hintStyle: const TextStyle(
                    color: AppColors.primaryGrey2,
                    fontFamily: AppFonts.manRope,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(16),
              // Amount field
              TextSemiBold(
                'Amount',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(8),
              TextFormField(
                controller: controller.amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: const TextStyle(
                    color: AppColors.primaryGrey2,
                    fontFamily: AppFonts.manRope,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(16),
              // Number of Users field
              TextSemiBold(
                'Number of User',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(8),
              TextFormField(
                controller: controller.quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter number of users',
                  hintStyle: const TextStyle(
                    color: AppColors.primaryGrey2,
                    fontFamily: AppFonts.manRope,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(16),
              // Type dropdown
              TextSemiBold(
                'Type',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(8),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedTypeCode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              // File upload area
              TextSemiBold(
                'Upload Image',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(8),
              Obx(() => InkWell(
                    onTap: controller.pickImage,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffE5E5E5),
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xffFAFAFA),
                      ),
                      child: controller.selectedImage != null
                          ? Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    controller.selectedImage!,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Gap(12),
                                const Text(
                                  'Tap to change image',
                                  style: TextStyle(
                                    fontFamily: AppFonts.manRope,
                                    fontSize: 13,
                                    color: AppColors.primaryGrey2,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 40,
                                  color: AppColors.primaryGrey2,
                                ),
                                const Gap(12),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Click here to Upload Document\n',
                                        style: TextStyle(
                                          fontFamily: AppFonts.manRope,
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '(5MB max)',
                                        style: TextStyle(
                                          fontFamily: AppFonts.manRope,
                                          fontSize: 12,
                                          color: AppColors.primaryGrey2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )),
              const Gap(16),
              // Payment Method Selection - Commented out as not in use
              // TextSemiBold(
              //   'Payment Method',
              //   fontSize: 14,
              //   fontWeight: FontWeight.w600,
              //   style: const TextStyle(fontFamily: AppFonts.manRope),
              // ),
              // const Gap(8),
              // Obx(() => InkWell(
              //       onTap: () => _showPaymentMethodBottomSheet(context),
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              //         decoration: BoxDecoration(
              //           border: Border.all(color: const Color(0xffE5E5E5)),
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               _getPaymentMethodLabel(controller.selectedPaymentMethod.value),
              //               style: const TextStyle(
              //                 fontFamily: AppFonts.manRope,
              //                 fontSize: 16,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryGrey2),
              //           ],
              //         ),
              //       ),
              //     )),
              const Gap(28),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: BusyButton(
                      title: "Create",
                      isLoading: controller.isCreating,
                      onTap: () async {
                        final success = await controller.createGiveaway();
                        if (success) Get.back();
                      },
                    ),
                  )),
              const Gap(20),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              if (detail.giver.photo.isNotEmpty)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(detail.giver.photo),
                  backgroundColor: const Color(0xffF3FFF7),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: detail.giver.photo.isEmpty
                      ? const Icon(Icons.person, size: 50, color: AppColors.primaryGrey2)
                      : null,
                )
              else
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xffF3FFF7),
                  child: Icon(Icons.person, size: 50, color: AppColors.primaryGrey2),
                ),
              const Gap(12),
              // Username with @ symbol
              TextSemiBold(
                '@${detail.giver.userName}',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(8),
              // Title/Description
              Text(
                detail.giveaway.description,
                style: const TextStyle(
                  fontFamily: AppFonts.manRope,
                  fontSize: 14,
                  color: AppColors.primaryGrey2,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              // Giveaway image
              if (detail.giveaway.image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    detail.giveaway.image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: const Color(0xffF3FFF7),
                      child: const Icon(Icons.image, size: 60, color: AppColors.primaryGrey2),
                    ),
                  ),
                ),
              const Gap(20),
              // Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffF9F9F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xffE5E5E5)),
                ),
                child: Column(
                  children: [
                    _detailRow('Type', detail.giveaway.type.toUpperCase()),
                    const Divider(height: 20, color: Color(0xffE5E5E5)),
                    _detailRow('Provider', detail.giveaway.typeCode.toUpperCase()),
                    const Divider(height: 20, color: Color(0xffE5E5E5)),
                    _detailRow('Amount', '₦${AmountUtil.formatFigure(double.tryParse(detail.giveaway.amount.toString()) ?? 0)}'),
                    const Divider(height: 20, color: Color(0xffE5E5E5)),
                    _detailRow('User', '${detail.requesters.length}/${detail.giveaway.quantity}'),
                  ],
                ),
              ),
              const Gap(20),
              // Claim button or completed message
              if (!detail.completed)
                SizedBox(
                  width: double.infinity,
                  child: BusyButton(
                    title: "Claim",
                    onTap: () => _showRecipientDialog(context, giveawayId),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: const Text(
                    'This giveaway has been fully claimed',
                    style: TextStyle(
                      fontFamily: AppFonts.manRope,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextSemiBold(
          label,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryGrey2,
          style: const TextStyle(fontFamily: AppFonts.manRope),
        ),
        TextSemiBold(
          value,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          style: GoogleFonts.arimo(),
        ),
      ],
    );
  }

  // Show recipient input dialog
  void _showRecipientDialog(BuildContext context, int giveawayId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBold(
                "Recipient",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(16),
              TextFormField(
                controller: controller.receiverController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter recipient',
                  hintStyle: const TextStyle(
                    color: AppColors.primaryGrey2,
                    fontFamily: AppFonts.manRope,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xffE5E5E5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                style: const TextStyle(fontFamily: AppFonts.manRope),
              ),
              const Gap(20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.receiverController.clear();
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: TextSemiBold(
                        "Cancel",
                        color: AppColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back(); // Close recipient dialog
                        final success = await controller.claimGiveaway(
                          giveawayId,
                          controller.receiverController.text,
                        );
                        if (success) {
                          controller.receiverController.clear();
                          Get.back(); // Close detail sheet
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: TextSemiBold(
                        "Continue",
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
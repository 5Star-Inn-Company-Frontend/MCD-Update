import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/core/import/imports.dart';
import './virtual_card_home_controller.dart';

class VirtualCardHomePage extends GetView<VirtualCardHomeController> {
  const VirtualCardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: TextSemiBold(
          'Virtual Card',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: false,
        actions: [
          Obx(() {
            if (controller.cards.isNotEmpty) {
              return IconButton(
                onPressed: () => Get.toNamed(Routes.VIRTUAL_CARD_REQUEST),
                icon: Icon(Icons.add_circle_outline,
                    color: AppColors.primaryGreen),
              );
            }
            return const SizedBox.shrink();
          })
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.cards.isEmpty) {
          return _buildEmptyState();
        } else {
          return _buildCardList();
        }
      }),
    );
  }

  Widget _buildCardList() {
    return RefreshIndicator(
      onRefresh: controller.refreshCards,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: controller.cards.length,
        separatorBuilder: (context, index) => const Gap(20),
        itemBuilder: (context, index) {
          final card = controller.cards[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.VIRTUAL_CARD_DETAILS,
                  arguments: {'cardModel': card});
            },
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getCardColor(card.brand),
                    _getCardColor(card.brand).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getCardColor(card.brand).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextBold(
                        card.brand.toUpperCase(),
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      const Icon(
                        Icons.contactless_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // TextBold(
                  //   '${card.currency} ${card.balance.toStringAsFixed(2)}',
                  //   fontSize: 28,
                  //   color: Colors.white,
                  //   fontWeight: FontWeight.w700,
                  // ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextSemiBold(
                        '**** **** **** ${card.cardNumber.length >= 4 ? card.cardNumber.substring(card.cardNumber.length - 4) : '****'}',
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      TextSemiBold(
                        card.status == 1 ? 'Active' : 'Inactive',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getCardColor(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1E3A8A); // Blue
      case 'mastercard':
        return const Color(0xFFEB001B); // Red-ish/Orange
      case 'verve':
        return AppColors.primaryGreen;
      default:
        return Colors.blueGrey;
    }
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(30),

          // Top circular icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircleIcon(
                  Color.fromRGBO(51, 160, 88, 0.1), Icons.credit_card, -50),
              Gap(80),
              _buildCircleIcon(Color.fromRGBO(51, 160, 85, 0.1),
                  Icons.account_balance_wallet, 30),
            ],
          ),
          Gap(20),

          // Center icon
          Center(
              child: _buildCircleIcon(
                  Color.fromRGBO(51, 160, 85, 0.1), Icons.payment, 0)),

          Gap(70),

          // Stacked Cards Image
          Center(
            child: Image.asset(
              'assets/images/vcards_home_screen.png',
              height: 400,
              width: 400,
            ),
          ),

          const Spacer(flex: 1),

          Text(
            'Digital Banking For The',
            style: GoogleFonts.montserrat(
                fontSize: 24, fontWeight: FontWeight.w900),
          ),

          Text(
            'Easiest Payments',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryGreen,
            ),
          ),
          const Gap(24),

          // Description
          TextSemiBold(
            'Get started by applying for your ATM Card with small fee and enjoy your transactions',
            fontSize: 14,
            color: Colors.grey,
          ),
          const Gap(40),

          SizedBox(
            width: 200,
            height: 56,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.VIRTUAL_CARD_REQUEST);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Gap(40),
                        TextBold(
                          'Get Started',
                          fontSize: 16,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(17.5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(40),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(Color bgColor, IconData icon, double offsetX) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.primaryGreen,
        size: 28,
      ),
    );
  }
}

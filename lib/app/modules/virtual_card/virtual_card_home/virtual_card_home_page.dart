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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Gap(30),
            
            // Top circular icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleIcon(Color.fromRGBO(51, 160, 88, 0.1), Icons.credit_card, -50),
                Gap(80),
                _buildCircleIcon(Color.fromRGBO(51, 160, 85, 0.1), Icons.account_balance_wallet, 30),
              ],
            ),
            Gap(20),
            
            // Center icon
            _buildCircleIcon(Color.fromRGBO(51, 160, 85, 0.1), Icons.payment, 0),
            Gap(40),
            
            // Stacked Cards
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Back card (green, rotated left)
                  Transform.rotate(
                    angle: -0.15,
                    child: Container(
                      width: 280,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/vcard.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  
                  // Front card (yellow/lime, rotated right)
                  Transform.rotate(
                    angle: 0.35,
                    child: Container(
                      width: 280,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.lime.shade600.withOpacity(0.6),
                            BlendMode.modulate,
                          ),
                          child: Image.asset(
                            'assets/images/vcard.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const Spacer(flex: 1),
            
            // Title
            TextBold(
              'Digital Banking For The',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              // textAlign: TextAlign.center,
            ),
            const Gap(8),
            
            // Subtitle with green text
            RichText(
              // textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppFonts.manRope,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Easiest Payments',
                    style: TextStyle(color: AppColors.primaryGreen),
                  ),
                ],
              ),
            ),
            const Gap(24),
            
            // Description
            TextSemiBold(
              'Get started by applying for your ATM Card with small fee and enjoy your transactions',
              fontSize: 14,
              textAlign: TextAlign.center,
              color: Colors.grey,
            ),
            const Gap(40),
            
            // Get Started Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.VIRTUAL_CARD_REQUEST);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextBold(
                      'Get Started',
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
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
            const Gap(40),
          ],
        ),
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
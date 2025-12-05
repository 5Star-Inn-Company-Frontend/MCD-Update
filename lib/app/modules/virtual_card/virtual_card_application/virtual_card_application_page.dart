import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/routes/app_pages.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import './virtual_card_application_controller.dart';

class VirtualCardApplicationPage extends GetView<VirtualCardApplicationController> {
  const VirtualCardApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String currency = args['currency'] ?? 'Dollar';
    final String cardType = args['cardType'] ?? 'Mater Card';
    final String amount = args['amount'] ?? '0';
    
    // Get user data from storage
    final String name = box.read('user_name') ?? 'Oluwa';
    final String email = box.read('user_email') ?? 'Oluwa@gmail.com';
    final String phone = box.read('user_phone') ?? '+23412345679 0';
    final String dob = box.read('user_dob') ?? '13-06-1890';

    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Card Application",
        elevation: 0,
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            
            // Subtitle
            TextSemiBold(
              'Confirm your details before you proceed',
              fontSize: 14,
              color: Colors.black87,
            ),
            const Gap(30),
            
            // Name
            _buildDetailRow('Name', name),
            const Gap(20),
            
            // Email address
            _buildDetailRow('Email address', email),
            const Gap(20),
            
            // Phone Number
            _buildDetailRow('Phone Number', phone),
            const Gap(20),
            
            // Date of birth
            _buildDetailRow('Date of birth', dob),
            const Gap(120),
            
            // Fee and Charges Section
            TextBold(
              'Fee and Charges',
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
            const Gap(20),
            
            // Issuance Fee
            _buildDetailRow('Issuance Fee', '\$2.00'),
            const Gap(20),
            
            // Maintenance Fee
            _buildDetailRow('Maintenance Fee', '\$0.50'),
            const Gap(60),
            
            // Apply Button
            BusyButton(
              title: 'Apply',
              onTap: () {
                // Navigate to card details or home
                Get.offNamed(Routes.VIRTUAL_CARD_DETAILS);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextSemiBold(
          label,
          fontSize: 16,
          color: Colors.black87,
        ),
        Flexible(
          child: TextSemiBold(
            value,
            fontSize: 16,
            color: Colors.black,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextSemiBold(
          label,
          fontSize: 16,
          color: Colors.black87,
        ),
        Flexible(
          child: TextSemiBold(
            value,
            fontSize: 16,
            color: Colors.black,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  
}

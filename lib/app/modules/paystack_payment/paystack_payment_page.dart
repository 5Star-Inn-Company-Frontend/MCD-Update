import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'paystack_payment_controller.dart';

class PaystackPaymentPage extends GetView<PaystackPaymentController> {
  const PaystackPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.onBackPressed();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: controller.onBackPressed,
          ),
          title: const Text(
            'Complete Payment',
            style: TextStyle(
              fontFamily: AppFonts.manRope,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller.webViewController),
            Obx(() => controller.isLoading.value
                ? Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading payment page...',
                            style: TextStyle(
                              fontFamily: AppFonts.manRope,
                              fontSize: 16,
                              color: AppColors.background.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

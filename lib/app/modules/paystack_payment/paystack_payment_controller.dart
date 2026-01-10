import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;

class PaystackPaymentController extends GetxController {
  late WebViewController webViewController;
  final isLoading = true.obs;
  final paymentUrl = ''.obs;
  final reference = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get arguments
    final args = Get.arguments;
    if (args != null) {
      paymentUrl.value = args['url'] ?? '';
      reference.value = args['reference'] ?? '';
    }
    
    dev.log('Payment URL: ${paymentUrl.value}', name: 'PaystackPayment');
    dev.log('Reference: ${reference.value}', name: 'PaystackPayment');
    
    _initializeWebView();
  }
  
  void _initializeWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.parse(request.url);
            
            // Handle deep links and external payment apps
            if (uri.scheme == 'btravel' || 
                uri.scheme == 'opay' || 
                uri.scheme == 'paystack' ||
                uri.scheme == 'intent' ||
                !['http', 'https'].contains(uri.scheme)) {
              dev.log('Handling external URL: ${request.url}', name: 'PaystackPayment');
              _launchExternalUrl(request.url);
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            dev.log('Page started loading: $url', name: 'PaystackPayment');
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            dev.log('Page finished loading: $url', name: 'PaystackPayment');
            isLoading.value = false;
            
            // Check if payment was completed or cancelled
            _checkPaymentStatus(url);
          },
          onWebResourceError: (WebResourceError error) {
            dev.log('Page resource error: ${error.description}', 
                name: 'PaystackPayment', error: error);
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl.value));
  }
  
  Future<void> _launchExternalUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        dev.log('Launched external URL', name: 'PaystackPayment');
      } else {
        dev.log('Cannot launch URL: $url', name: 'PaystackPayment');
        Get.snackbar(
          'Error',
          'Unable to open payment app. Please ensure it is installed.',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      dev.log('Error launching external URL: $e', name: 'PaystackPayment');
    }
  }
  
  void _checkPaymentStatus(String url) {
    // Paystack redirects to a URL with status after payment
    if (url.contains('status=success') || 
        url.contains('trxref=${reference.value}') ||
        url.contains('standard.paystack.co/close')) {
      dev.log('Payment successful or completed', name: 'PaystackPayment');
      
      // Small delay to ensure user sees the success message
      Future.delayed(const Duration(seconds: 2), () {
        Get.back(result: true);
      });
    } else if (url.contains('status=cancelled') || 
               url.contains('cancelled=true')) {
      dev.log('Payment cancelled', name: 'PaystackPayment');
      
      Future.delayed(const Duration(seconds: 1), () {
        Get.back(result: false);
      });
    }
  }
  
  void onBackPressed() {
    Get.defaultDialog(
      title: 'Cancel Payment?',
      middleText: 'Are you sure you want to cancel this payment?',
      textConfirm: 'Yes, Cancel',
      textCancel: 'No, Continue',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(); // Close dialog
        Get.back(result: false); // Close payment screen
      },
    );
  }
}

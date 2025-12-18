import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/core/services/connectivity_service.dart';

class NoConnectionBanner extends StatelessWidget {
  const NoConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();
    
    return Obx(() {
      if (!connectivityService.showNoConnectionBanner.value) {
        return const SizedBox.shrink();
      }
      
      return Material(
        elevation: 4,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'No Internet Connection',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Please check your connection',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final hasConnection = await connectivityService.verifyConnection();
                    if (hasConnection) {
                      Get.snackbar(
                        'Connected',
                        'Internet connection restored',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                      );
                    }
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 18),
                  label: const Text(
                    'Retry',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

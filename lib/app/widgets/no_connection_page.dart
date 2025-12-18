import 'package:flutter/material.dart';

class NoConnectionPage extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;
  
  const NoConnectionPage({
    super.key,
    this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // No internet animation/icon
                Icon(
                  Icons.wifi_off_rounded,
                  size: 120,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 32),
                Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  message ?? 'Please check your internet connection and try again.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (onRetry != null)
                  ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

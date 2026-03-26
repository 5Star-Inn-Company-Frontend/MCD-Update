import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/import/imports.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Expecting Map<String, dynamic> in arguments
    final Map<String, dynamic> data = Get.arguments ?? {};
    final String title = data['title'] ?? 'Notification';
    final String body = data['body'] ?? '';
    final String dateString = data['date'] ?? '';
    final String type = data['type'] ?? 'general';

    return Scaffold(
      appBar: PaylonyAppBarTwo(
        title: 'Detail',
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon header
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconForType(type),
                  size: 32,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Title
            TextBold(
              title,
              fontSize: 20,
              color: Colors.black,
            ),
            const SizedBox(height: 8),
            // Date
            TextSmall(
              dateString.isEmpty
                  ? 'Received just now'
                  : _formatSourceDate(dateString),
              fontSize: 13,
              color: AppColors.primaryGrey,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            // Body
            TextBody(
              body,
              fontSize: 15,
              height: 1.6,
              color: Colors.black87,
              maxLines: 100,
            ),
            const SizedBox(height: 48),
            // Back button
            BusyButton(
              title: 'Back to Dashboard',
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'transaction':
        return Icons.swap_horiz;
      case 'deposit':
        return Icons.account_balance_wallet;
      case 'security':
        return Icons.security;
      case 'promo':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }

  String _formatSourceDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy • h:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/app/modules/pos/pos_terminal_requests_module/models/pos_request_model.dart';

class PosRequestDetailsPage extends StatelessWidget {
  final PosRequestModel request;

  const PosRequestDetailsPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Request Details",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(
              title: "Terminal Details",
              children: [
                // _buildRow("Terminal Type",
                //     "MP35P Terminal"), // Using fixed type as per design for now or fetch if available
                _buildRow("Reference", request.reference),
                _buildRow("Request Date",
                    "${request.formattedDate} ${request.formattedTime}"),
              ],
            ),
            const Gap(16),
            _buildSection(
              title: "Account Details",
              children: [
                _buildRow("Account Type", request.accountType),
                _buildRow("Purchase Type", request.formattedPurchaseType),
                _buildRow("Initial Payment",
                    request.formattedAmountPaid), // Simulating logic
                _buildRow("Amount Paid", request.formattedAmountPaid),
                _buildRow("Amount Unpaid", request.formattedAmountUnpaid),
                _buildRow("Total Payment", request.formattedAmount),
              ],
            ),
            const Gap(16),
            _buildSection(
              title: "Request Status",
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      request.statusText,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(112, 112, 112, 1),
                      ),
                    ),
                  ],
                )
              ],
            ),
            // show continue to payment button if pending and unpaid
            if (request.status == 0 && request.paymentStatus == 0) ...[
              const Gap(24),
              _buildContinueToPaymentButton(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color.fromRGBO(51, 51, 51, 1),
            ),
          ),
          const Gap(16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(112, 112, 112, 1),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color.fromRGBO(51, 51, 51, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueToPaymentButton(BuildContext context) {
    return BusyButton(
      title: 'Continue to Payment',
      onTap: () async {
        final url = request.authorizationUrl;
        if (url != null && url.isNotEmpty) {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open payment page')),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment link not available')),
          );
        }
      },
    );
  }
}

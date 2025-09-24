import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class PosTerminalTransactionHistoryScreen extends StatefulWidget {
  const PosTerminalTransactionHistoryScreen({super.key});

  @override
  State<PosTerminalTransactionHistoryScreen> createState() => _PosTerminalTransactionHistoryScreenState();
}

class _PosTerminalTransactionHistoryScreenState extends State<PosTerminalTransactionHistoryScreen> {
  bool transactionSuccess = true;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _transactions = [
    {'date': '2023/10/01', 'time': '09:33', 'amount': '₦100,000.00', 'description': 'Cable TV Subscription', 'status': 'Successful', 'type': 'sent'},
    {'date': '2023/10/01', 'time': '10:32', 'amount': '₦200,000.00', 'description': 'Deposit', 'status': 'Failed', 'type': 'received'},
    {'date': '2023/10/03', 'time': '21:34', 'amount': '₦150,000.00', 'description': 'Payment', 'status': 'Successful', 'type': 'sent'},
    {'date': '2023/10/04', 'time': '01:13', 'amount': '₦50,000.00', 'description': 'Refund', 'status': 'Successful', 'type': 'received'},
    {'date': '2023/10/05', 'time': '09:33', 'amount': '₦100,000.00', 'description': 'Withdrawal', 'status': 'Failed', 'type': 'received'},
    {'date': '2023/10/05', 'time': '10:32', 'amount': '₦200,000.00', 'description': 'Deposit', 'status': 'Successful', 'type': 'received'},
    {'date': '2023/10/06', 'time': '21:34', 'amount': '₦150,000.00', 'description': 'Cable TV Subscription', 'status': 'Failed', 'type': 'sent'},
  ];

  List<Map<String, String>> get _filteredTransactions {
    if (_searchQuery.isEmpty) {
      return _transactions;
    } else {
      return _transactions
          .where((transaction) =>
              transaction['description']!.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Transaction History",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
            const Gap(10),
            SearchBar(
              controller: _searchController,
              hintText: 'Search transactions...',
              hintStyle: WidgetStatePropertyAll(GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(211, 208, 217, 1))),
              leading: const Icon(Icons.search),
              trailing: [
                _searchQuery.isNotEmpty
                ? IconButton(icon: const Icon(Icons.close), onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                : Row(
                  children: [
                    const Icon(Icons.date_range_rounded),
                    const Gap(5),
                    Text('Today', style: GoogleFonts.manrope(fontSize: 11.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(192, 192, 192, 1)),)
                  ],
                )
              ],
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              side: const WidgetStatePropertyAll(BorderSide(color: Color.fromRGBO(211, 208, 217, 1), width: 1)),
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              onTap: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            ),
            const Gap(20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _filteredTransactions[index];
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: screenHeight(context) * 0.05,
                                width: screenWidth(context) * 0.1,
                                child: CircleAvatar(
                                  backgroundColor: transaction['type'] == 'received' ? const Color.fromRGBO(90, 187, 123, 0.2) : const Color.fromRGBO(255, 188, 207, 0.3),
                                  child: transaction['type'] == 'received' ? SvgPicture.asset("assets/icons/received.svg") : SvgPicture.asset("assets/icons/send.svg"),
                                ),
                              ),
                              const Gap(10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(transaction['description']!, style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
                                  const Gap(5),
                                  Row(
                                    children: [
                                      Text(transaction['date']!, style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                                      const Gap(5),
                                      Text(transaction['time']!, style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(transaction['amount']!, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w400, color: transaction['status'] == 'Successful' ? const Color.fromRGBO(62, 178, 91, 1) : const Color.fromRGBO(255, 58, 68, 1))),
                              Text(transaction['status']!, style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
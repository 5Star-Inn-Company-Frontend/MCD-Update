import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';

class PosTerminalRequestsScreen extends StatefulWidget {
  const PosTerminalRequestsScreen({super.key});

  @override
  State<PosTerminalRequestsScreen> createState() => _PosTerminalRequestsScreenState();
}

class _PosTerminalRequestsScreenState extends State<PosTerminalRequestsScreen> {
  final List<Map<String, String>> _terminalRequestsList = [
    {'date': '2023/10/01', 'time': '09:33', 'amount': '₦100,000.00', 'terminal_type': 'K11 Terminal', 'purchaseType': 'Outright Purchase', },
    {'date': '2023/10/01', 'time': '10:32', 'amount': '₦200,000.00', 'terminal_type': 'Terminal 2', 'purchaseType': 'Other Purchase', },
    {'date': '2023/10/03', 'time': '21:34', 'amount': '₦150,000.00', 'terminal_type': 'Termial Type 3', 'purchaseType': 'Outright Purchase', },
    {'date': '2023/10/04', 'time': '01:13', 'amount': '₦50,000.00', 'terminal_type': 'K11 Terminal', 'purchaseType': 'Outright Purchase', },
    {'date': '2023/10/05', 'time': '09:33', 'amount': '₦100,000.00', 'terminal_type': 'Termial Type 3', 'purchaseType': 'Other Purchase', },
    {'date': '2023/10/05', 'time': '10:32', 'amount': '₦200,000.00', 'terminal_type': 'Terminal 2', 'purchaseType': 'Outright Purchase', },
    {'date': '2023/10/06', 'time': '21:34', 'amount': '₦150,000.00', 'terminal_type': 'K11 Terminal', 'purchaseType': 'Other Purchase', },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Terminal Requests",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            const Gap(20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _terminalRequestsList.length,
              itemBuilder: (context, index) {
                final request = _terminalRequestsList[index];
                return _requestTile(
                  request['terminal_type'] ?? '', request['date'] ?? '', request['time'] ?? '', request['purchaseType'] ?? '', request['amount'] ?? ''
                );
              }
            )
          ]
        )
      )
    );
  }

  Widget _requestTile(String terminalType, String date, String time, String purchaseType, String amount) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>PosTermRequestDetailScreen(
          terminalTypeDetail: terminalType,
          dateDetail: date,
          timeDetail: time,
        )));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(terminalType, style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),
                
                Text('Request Date: $date $time', style: GoogleFonts.manrope(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),)
              ]
            ),
      
             Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(purchaseType, style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(112, 112, 112, 1)),),
                
                Text(amount, style: GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),)
              ]
            )
          ],
        ),
      ),
    );
  }
}


class PosTermRequestDetailScreen extends StatefulWidget {
  final String terminalTypeDetail;
  final String dateDetail;
  final String timeDetail;
  const PosTermRequestDetailScreen({super.key, required this.terminalTypeDetail, required this.dateDetail, required this.timeDetail});

  @override
  State<PosTermRequestDetailScreen> createState() => _PosTermRequestDetailScreenState();
}

class _PosTermRequestDetailScreenState extends State<PosTermRequestDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PaylonyAppBarTwo(
        title: "Terminal Details",
        elevation: 0,
        centerTitle: false,
        actions: [],
      ),
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            const Gap(20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Terminal Details', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),)
                    ],
                  ),

                  const Gap(20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Terminal Type', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      
                          Text('Reference:', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      
                          Text('Request Date:', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),)
                        ],
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(widget.terminalTypeDetail, style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('3D903534', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('${widget.dateDetail} ${widget.timeDetail}', style: GoogleFonts.roboto(fontSize: 10.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),)
                        ],
                      )
                    ],
                  ),
                ]
              ),
            ),

            const Gap(20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Account Details', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),)
                    ],
                  ),

                  const Gap(20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Account Type', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      
                          Text('Purchase Type', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),
                      
                          Text('Initial Payment', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('Amount Paid', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('Amount Unpaid', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('Total Payment', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),)
                        ],
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Agent', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('Investment', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('60,000.00', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('60,000.00', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('80,000.00', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),),

                          Text('140,000.00', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),)
                        ],
                      )
                    ],
                  ),
                ]
              ),
            ),

            const Gap(20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Request Status', style: GoogleFonts.manrope(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color.fromRGBO(51, 51, 51, 1)),),

                  Text('Under Review', style: GoogleFonts.roboto(fontSize: 12.sp, fontWeight: FontWeight.w400, color: const Color.fromRGBO(112, 112, 112, 1)),)
                ],
              ),
            )
          ]
        )
      )
    );
  }
}
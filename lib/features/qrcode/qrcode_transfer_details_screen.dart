import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class QRCodeTransferDetailsScreen extends StatefulWidget {
  const QRCodeTransferDetailsScreen({super.key});

  @override
  State<QRCodeTransferDetailsScreen> createState() =>
      _QRCodeTransferDetailsScreenState();
}

class _QRCodeTransferDetailsScreenState
    extends State<QRCodeTransferDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PaylonyAppBarTwo(
          title: 'Transfer',
          centerTitle: false,
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      height: screenHeight(context) * 0.2,
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 24, right: 10, left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromRGBO(224, 224, 224, 1),
                              width: 1),
                          borderRadius: BorderRadius.circular(2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Username',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: AppFonts.manRope,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              Text(
                                'Tesd',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: AppFonts.manRope,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Email address',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: AppFonts.manRope,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              Text(
                                'admin@5starcompany.com.ng',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: AppFonts.manRope,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Current Wallet',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: AppFonts.manRope,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              ),
                              RichText(
                                text: TextSpan(
                                  text: '#100',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: AppFonts.manRope,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '.00',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: AppFonts.manRope,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.04,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Enter Amount',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppFonts.manRope,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                      ],
                    ),
                    TextField(
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: AppFonts.manRope,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: '0.00',
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: AppFonts.manRope,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(3)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                  width: 1),
                              borderRadius: BorderRadius.circular(3))),
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.15,
                    ),
                    BusyButton(
                        height: screenHeight(context) * 0.06,
                        width: screenWidth(context) * 0.65,
                        title: "Transfer",
                        onTap: () {}),
                  ]),
                ))));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class QRCodeRequestFundDetailsScreen extends StatefulWidget {
  const QRCodeRequestFundDetailsScreen({super.key});

  @override
  State<QRCodeRequestFundDetailsScreen> createState() =>
      _QRCodeRequestFundDetailsScreenState();
}

class _QRCodeRequestFundDetailsScreenState
    extends State<QRCodeRequestFundDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PaylonyAppBarTwo(
          title: 'Request for Fund',
          centerTitle: false,
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      height: screenHeight(context) * 0.14,
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          top: 24, bottom: 24, right: 10, left: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromRGBO(224, 224, 224, 1),
                              width: 1),
                          borderRadius: BorderRadius.circular(2)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                          Row(
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
                        title: "Request",
                        onTap: () {}),
                  ]),
                ))));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PaylonyAppBarTwo(
          title: 'Notification',
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  // const Gap(10),
                  notifyListTile(
                      false, 'New Account created', false, 'Today at 9:42 AM'),

                  notifyListTile(
                      false,
                      'Tesd requested for #500 from your wallet',
                      true,
                      'Today at 9:42 AM'),

                  notifyListTile(true, 'Dear Customer, Happy Friday!', false,
                      'Last Wednesday at 9:42 AM'),

                  notifyListTile(
                      true,
                      'Funding Update, Important Update on \nFunding Delays from Mega Cheap Data',
                      false,
                      '12 May 2024 at 9:42 AM'),
                ]))));
  }

  Widget notifyListTile(
      bool checked, String message, bool fundRequest, String date) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          // height: screenHeight(context) * 0.15,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/notify-icon.svg',
                      ),
                      if (checked == false)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: AppFonts.manRope,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                  const SizedBox(
                    height: 10,
                  ),
                  if (fundRequest == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BusyButton(
                            width: screenWidth(context) * 0.3,
                            title: "Approve",
                            onTap: () {}),
                        const SizedBox(width: 20),
                        BusyButton(
                          width: screenWidth(context) * 0.3,
                          title: "Decline",
                          onTap: () {},
                          textColor: Colors.black,
                          color: Colors.white,
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(date,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: AppFonts.manRope,
                          fontWeight: FontWeight.w300,
                          fontSize: 14.sp))
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const Divider()
      ],
    );
  }
}

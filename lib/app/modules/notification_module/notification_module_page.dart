import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/notification_module/notification_module_controller.dart';
import 'package:mcd/app/widgets/app_bar-two.dart';
import 'package:mcd/app/widgets/busy_button.dart';
import 'package:mcd/core/constants/fonts.dart';
import 'package:mcd/core/utils/ui_helpers.dart';

class NotificationModulePage extends GetView<NotificationModuleController> {
  const NotificationModulePage({super.key});

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
                child: Column(
                    children: controller.notifications
                        .map((notification) => _notifyListTile(
                            context,
                            notification.checked,
                            notification.message,
                            notification.fundRequest,
                            notification.date))
                        .toList()))));
  }

  Widget _notifyListTile(BuildContext context, bool checked, String message,
      bool fundRequest, String date) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        SizedBox(
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
                            onTap: controller.approveRequest),
                        const SizedBox(width: 20),
                        BusyButton(
                          width: screenWidth(context) * 0.3,
                          title: "Decline",
                          onTap: controller.declineRequest,
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
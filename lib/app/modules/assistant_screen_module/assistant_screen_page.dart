import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/assistant_screen_module/widgets/message_bubble.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/utils/bottom_navigation.dart';
import 'package:mcd/app/widgets/app_bar.dart';
import 'package:mcd/core/constants/app_asset.dart';
import './assistant_screen_controller.dart';

class AssistantScreenPage extends GetView<AssistantScreenController> {
  const AssistantScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context) ?? false;
      },
      child: Scaffold(
      appBar: PaylonyAppBar(
        title: "MCD Assistant",
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: SvgPicture.asset(AppAsset.chatAssistant),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Stack(
          children: [
            Obx(() => Visibility(
              visible: controller.chatMessages.isEmpty,
              child: Align(
                alignment: Alignment.center,
                child: TextSemiBold(
                  "Ask anything, get yout answer",
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.primaryColor,
                  textAlign: TextAlign.center,
                ),
              ),
            )),
            Obx(() => ListView.builder(
                itemCount: controller.chatMessages.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                      messageText: controller.chatMessages[index].text,
                      isMe: true);
                })),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                    filled: true,
                    suffixIcon: GestureDetector(
                      onTap: controller.addMessage,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(AppAsset.sendMessage),
                      ),
                    ),
                    fillColor: AppColors.filledInputColor,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: AppColors.filledBorderIColor, width: 1)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                            color: AppColors.filledBorderIColor, width: 1))),
              ),
            )
          ],
        ),
      ),
        bottomNavigationBar: const BottomNavigation(selectedIndex: 3),
      ),
    );
  }

  Future<bool?> _showExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/utils/bottom_navigation.dart';
import 'package:mcd/app/widgets/app_bar.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/features/home/widgets.dart/chat_bubble.dart';
import './assistant_screen_controller.dart';

class AssistantScreenPage extends GetView<AssistantScreenController> {
  const AssistantScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

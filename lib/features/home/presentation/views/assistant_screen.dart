import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/app/styles/fonts.dart';
import 'package:mcd/app/widgets/app_bar.dart';
import 'package:mcd/core/constants/app_asset.dart';
import 'package:mcd/features/home/data/model/chat_model.dart';
import 'package:mcd/features/home/widgets.dart/chat_bubble.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  bool noChats = false;
  TextEditingController controller = TextEditingController();
  final List<ChatMessage> chatMessages = [];
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.white,
      appBar: PaylonyAppBar(
        // automaticallyImplyLeading: false,
        // backgroundColor: AppColors.white,
        title: "MCD Assistant",
        // elevation: 2,
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
            Visibility(
              visible: chatMessages.isEmpty,
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
            ),
            ListView.builder(
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                
                 
                  return MessageBubble(
                      messageText: chatMessages[index].text, isMe: true);
                }),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    filled: true,
                    suffixIcon: GestureDetector(
                      onTap: _addMessage,
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
    );
  }

  void _addMessage() {
    setState(() {
      chatMessages.add(
        ChatMessage(text: controller.text, timestamp: DateTime.now()),
      );
      controller.clear();
      // messages.add('New Message ${messages.length + 1}');
    });
  }
}

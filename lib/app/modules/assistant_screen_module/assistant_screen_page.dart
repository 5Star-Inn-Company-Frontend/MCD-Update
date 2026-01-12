import 'package:mcd/app/modules/assistant_screen_module/widgets/message_bubble.dart';
import 'package:mcd/app/utils/bottom_navigation.dart';
import 'package:mcd/app/widgets/app_bar.dart';
import 'package:mcd/core/import/imports.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Stack(
            children: [
              Obx(() => Visibility(
                    visible: controller.chatMessages.isEmpty &&
                        !controller.isLoadingHistory,
                    child: Align(
                      alignment: Alignment.center,
                      child: TextSemiBold(
                        "Ask anything, get you answer",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.primaryColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
              Obx(() => Visibility(
                    visible: controller.isLoadingHistory,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  )),
              Obx(() => ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.only(
                      bottom: 100), // Add padding for input field
                  itemCount: controller.chatMessages.length +
                      (controller.isThinking ? 1 : 0),
                  itemBuilder: (context, index) {
                    // If thinking, show indicator at index 0 (bottom)
                    if (controller.isThinking && index == 0) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                          child: Text(
                            "Thinking...",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }

                    // Adjust index if thinking indicator is present
                    final listIndex = controller.isThinking ? index - 1 : index;
                    final message = controller.chatMessages[listIndex];

                    return MessageBubble(
                        messageText: message.text, isMe: !message.isAi);
                  })),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  controller: controller.messageController,
                  style: TextStyle(fontFamily: AppFonts.manRope),
                  decoration: InputDecoration(
                      hintText: "Type here...",
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: AppFonts.manRope),
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
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              color: AppColors.filledBorderIColor, width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(
                              color: AppColors.filledBorderIColor, width: 1))),
                ),
              ),
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
        backgroundColor: AppColors.white,
        title: const Text('Exit App',
            style: TextStyle(fontFamily: AppFonts.manRope)),
        content: const Text('Do you want to exit the app?',
            style: TextStyle(fontFamily: AppFonts.manRope)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No',
                style: TextStyle(fontFamily: AppFonts.manRope)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes',
                style: TextStyle(fontFamily: AppFonts.manRope)),
          ),
        ],
      ),
    );
  }
}

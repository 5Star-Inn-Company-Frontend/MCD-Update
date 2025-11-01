import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/home_screen_module/model/chat_model.dart';
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class AssistantScreenController extends GetxController {
  final messageController = TextEditingController();
  
  final _chatMessages = <ChatMessage>[].obs;
  List<ChatMessage> get chatMessages => _chatMessages;

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void addMessage() {
    if (messageController.text.trim().isEmpty) return;
    
    _chatMessages.add(
      ChatMessage(
        text: messageController.text,
        timestamp: DateTime.now(),
      ),
    );
    messageController.clear();
  }
}

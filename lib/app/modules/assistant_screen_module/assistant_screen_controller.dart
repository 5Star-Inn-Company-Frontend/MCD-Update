import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mcd/app/modules/home_screen_module/model/chat_model.dart';
import 'package:mcd/core/services/ai_assistant_service.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'dart:developer' as dev;
/**
 * GetX Template Generator - fb.com/htngu.99
 * */

class AssistantScreenController extends GetxController {
  final messageController = TextEditingController();
  final AiAssistantService _aiService = AiAssistantService();

  final _chatMessages = <ChatMessage>[].obs;
  List<ChatMessage> get chatMessages => _chatMessages;

  final _isTyping = false.obs;
  bool get isTyping => _isTyping.value;

  final _connectionStatus = 'Disconnected'.obs;
  String get connectionStatus => _connectionStatus.value;

  final _isThinking = false.obs;
  bool get isThinking => _isThinking.value;

  final _isLoadingHistory = false.obs;
  bool get isLoadingHistory => _isLoadingHistory.value;

  String _currentStreamResponse = '';

  @override
  void onInit() {
    super.onInit();
    _initializeAiService();
  }

  void _initializeAiService() {
    _aiService.initSocket();

    _aiService.onStatusChange = (status) {
      _connectionStatus.value = status;
      if (status.toString().contains('processing')) {
        _isThinking.value = true;
        _isTyping.value = false;
      } else if (status.toString().contains('idle')) {
        _isThinking.value = false;
        _isTyping.value = false;
      }
    };

    _aiService.onResponse = (data) {
      _isThinking.value = false;
      _isTyping.value = false;

      // If we were streaming, finalize the message
      if (_currentStreamResponse.isNotEmpty) {
        _finalizeStreamMessage();
      } else {
        // Handle non-streamed full response
        // User log: Response: {content: Hello...}
        String? messageText;
        if (data is Map && data.containsKey('content')) {
          messageText = data['content'];
        } else if (data is Map && data.containsKey('message')) {
          messageText = data['message'];
        } else {
          messageText = data.toString();
        }

        if (messageText != null) {
          _addBotMessage(messageText);
        }
      }
    };

    _aiService.onError = (error) {
      _isTyping.value = false;
      _isLoadingHistory.value = false;
      Get.snackbar(
        'Error',
        error.toString(),
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
      );
    };

    _aiService.onChatStream = (chunk) {
      _isTyping.value = true;
      _currentStreamResponse += chunk;
      _updateStreamingMessage(_currentStreamResponse);
    };

    _aiService.onHistory = (history) {
      _isLoadingHistory.value = true;
      dev.log('Loading ${history.length} messages from history',
          name: 'AiAssistant');

      // Clear existing messages
      _chatMessages.clear();

      // Parse and add history messages
      // History comes in chronological order (oldest first)
      // Since we use reverse ListView, we need to reverse the history
      // so newest messages appear at bottom (index 0)
      for (var msg in history.reversed) {
        if (msg is Map) {
          final role = msg['role']?.toString() ?? '';
          final content =
              msg['content']?.toString() ?? msg['message']?.toString() ?? '';

          if (content.isNotEmpty) {
            // Add to end of list (newest first for reverse ListView)
            _chatMessages.add(ChatMessage(
              text: content,
              timestamp: DateTime.now(), // Could parse timestamp if provided
              isAi: role == 'assistant' || role == 'ai',
            ));
          }
        }
      }

      dev.log('Loaded ${_chatMessages.length} messages into chat',
          name: 'AiAssistant');
      _isLoadingHistory.value = false;
    };

    _aiService.onChatLimit = (data) {
      _isThinking.value = false;
      _isTyping.value = false;

      String message = 'You have reached your chat limit.';
      if (data is Map && data.containsKey('message')) {
        message = data['message'].toString();
      } else if (data is String) {
        message = data;
      }

      Get.snackbar(
        'Chat Limit Reached',
        message,
        backgroundColor: AppColors.errorBgColor,
        colorText: AppColors.textSnackbarColor,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
      );
    };
  }

  @override
  void onClose() {
    messageController.dispose();
    _aiService.dispose();
    super.onClose();
  }

  void addMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message immediately
    _chatMessages.insert(
      0,
      ChatMessage(
        text: text,
        timestamp: DateTime.now(),
        // isMe field is likely in the model, let's assume default or we handle it in UI
      ),
    );

    messageController.clear();
    _isTyping.value = true;
    _currentStreamResponse = '';

    // Send to socket
    _aiService.sendMessage(text);
  }

  void _addBotMessage(String text) {
    _chatMessages.insert(
      0,
      ChatMessage(
        text: text,
        timestamp: DateTime.now(),
        isAi: true, // Assuming ChatMessage has this or we infer from isMe=false
      ),
    );
  }

  void _updateStreamingMessage(String text) {
    // If the last message (index 0) is from AI and we are streaming, update it
    if (_chatMessages.isNotEmpty &&
        (_chatMessages.first.isAi) &&
        _currentStreamResponse.isNotEmpty) {
      _chatMessages[0] = ChatMessage(
        text: text,
        timestamp: DateTime.now(),
        isAi: true,
      );
      // _chatMessages.refresh(); // Obx should handle list item updates if we replace the item?
      // Actually RxList updates on operation. replacing index 0 works.
    } else {
      // Start new AI message
      _addBotMessage(text);
    }
  }

  void _finalizeStreamMessage() {
    _currentStreamResponse = '';
  }
}

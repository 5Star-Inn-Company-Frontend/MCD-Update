import 'package:flutter/material.dart';
import 'package:mcd/app/styles/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final String messageText;
  final bool isMe;

  const MessageBubble(
      {super.key, required this.messageText, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe
          ? const EdgeInsets.only(right: 12, left: 40, bottom: 5, top: 8)
          : const EdgeInsets.only(right: 40, left: 12, bottom: 5, top: 8),
      child: Align(
        alignment: isMe ? Alignment.topRight : Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primaryGreen : AppColors.primaryGreen.withOpacity(0.2),
            borderRadius: isMe ? 
            const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(0),
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ):const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(20),
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Text(
            messageText,
            style: TextStyle(color: isMe ? AppColors.white : Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
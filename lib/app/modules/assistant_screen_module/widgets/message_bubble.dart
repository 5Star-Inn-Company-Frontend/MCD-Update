import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mcd/app/styles/app_colors.dart';
import 'package:mcd/core/constants/fonts.dart';

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
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isMe
                ? AppColors.primaryGreen
                : AppColors.primaryGreen.withOpacity(0.2),
            borderRadius: isMe
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
          ),
          child: isMe
              ? Text(
                  messageText,
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.manRope),
                )
              : MarkdownBody(
                  data: messageText,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppFonts.manRope,
                    ),
                    strong: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.manRope,
                    ),
                    em: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontFamily: AppFonts.manRope,
                    ),
                    code: TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                      fontFamily: 'monospace',
                      backgroundColor: Colors.grey.withOpacity(0.2),
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    listBullet: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppFonts.manRope,
                    ),
                    h1: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.manRope,
                    ),
                    h2: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.manRope,
                    ),
                    h3: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.manRope,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

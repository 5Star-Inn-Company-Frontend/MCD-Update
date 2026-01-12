class ChatMessage {
  final String text;
  final DateTime timestamp;
  final bool isAi;
  final bool
      isMe; // Keeping for backward compatibility or clarity if needed, though !isAi serves same.

  ChatMessage({
    required this.text,
    required this.timestamp,
    this.isAi = false,
    this.isMe = true,
  });
}

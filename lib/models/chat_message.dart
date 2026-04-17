enum MessageType { sent, received, richCard }

class ChatMessage {
  final String text;
  final String senderInitial;
  final MessageType type;
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? uiCode;
  final DateTime timestamp;
  final String displayType;
  bool isWaiting;

  ChatMessage({
    this.displayType = 'text',
    required this.text,
    this.senderInitial = 'T',
    required this.type,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.uiCode,
    this.isWaiting = false,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

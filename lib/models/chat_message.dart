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

  ChatMessage({
    required this.text,
    this.senderInitial = 'T',
    required this.type,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.uiCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

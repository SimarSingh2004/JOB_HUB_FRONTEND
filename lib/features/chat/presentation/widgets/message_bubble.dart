import 'package:flutter/material.dart';
import '../../../../models/message.dart';

// A single chat bubble.
// isMine=true → right side, purple background (sender)
// isMine=false → left side, white background (receiver)
class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMine;
  final bool showTime; // only show timestamp on last message in a group

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.showTime = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isMine ? 64 : 16, // mine: push from left, theirs: push from right
        right: isMine ? 16 : 64,
        bottom: showTime ? 12 : 4,
      ),
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMine ? const Color(0xFF4F46E5) : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isMine ? 16 : 4),
                bottomRight: Radius.circular(isMine ? 4 : 16),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              message.text,
              style: TextStyle(
                fontSize: 14,
                color: isMine ? Colors.white : const Color(0xFF1A1A2E),
                height: 1.4,
              ),
            ),
          ),

          // Timestamp — only shown when showTime is true
          if (showTime && message.createdAt != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _formatTime(message.createdAt!),
                style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toLocal();
      final hour = date.hour.toString().padLeft(2, '0');
      final min = date.minute.toString().padLeft(2, '0');
      return '$hour:$min';
    } catch (_) {
      return '';
    }
  }
}

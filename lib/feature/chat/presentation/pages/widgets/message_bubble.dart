import 'package:chat_app/feature/chat/data/models/message_model.dart';
import 'package:chat_app/feature/chat/presentation/pages/widgets/Typing_Indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isSentByMe;
    final isTyping = message.content.trim().toLowerCase() == 'typing...';

    final String formattedTime = DateFormat('HH:mm').format(message.timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isTyping
              ? Colors.grey[400]
              : isMe
                  ? const Color(0xFF00BF6C)
                  : const Color.fromARGB(255, 1, 75, 90),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(32),
            topRight: const Radius.circular(32),
            bottomLeft:
                isMe ? const Radius.circular(32) : const Radius.circular(0),
            bottomRight:
                isMe ? const Radius.circular(0) : const Radius.circular(32),
          ),
        ),
        child: isTyping
            ? const TypingIndicator()
            : Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.content,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

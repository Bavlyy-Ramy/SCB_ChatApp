import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chat_app/feature/chat/data/models/message_model.dart';
import 'package:chat_app/feature/chat/presentation/pages/widgets/typing_indicator.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final isMe = message.isSentByMe;
    final isTyping = message.content?.trim().toLowerCase() == 'typing...';
    final isImage = message.imagePath != null && message.imagePath!.isNotEmpty;

    final String formattedTime = DateFormat('HH:mm').format(message.timestamp);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isTyping || isImage
              ? Colors.grey[400]
              : isMe
                  ? const Color(0xFF00BF6C)
                  : const Color.fromARGB(255, 1, 75, 90),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(32),
            topRight: const Radius.circular(32),
            bottomLeft: isMe ? const Radius.circular(32) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(32),
          ),
        ),
        child: isTyping
            ? const TypingIndicator()
            : Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isImage)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        File(message.imagePath!),
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Text(
                      message.content ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  const SizedBox(height: 3),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

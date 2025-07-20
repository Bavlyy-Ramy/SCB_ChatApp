import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:chat_app/feature/chat/data/models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial()) {
    loadInitialMessages();
  }

  List<MessageModel> _messages = [];
  String _inputText = '';

  void loadInitialMessages() {
    _messages = [
      MessageModel(
        content: 'Hello, how are you?',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        content: 'I\'m fine!',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      MessageModel(
        content: 'What are you doing?',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      MessageModel(
        content: 'Working',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      MessageModel(
        content: 'Cool!',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];

    emit(ChatLoaded(messages: _messages, inputText: _inputText));
  }

  void updateInputText(String value) {
    _inputText = value;
    emit(ChatLoaded(messages: _messages, inputText: _inputText));
  }

  Future<void> sendMessage() async {
    if (_inputText.trim().isEmpty) return;

    // 1. Add user's message
    final userMessage = MessageModel(
      content: _inputText.trim(),
      isSentByMe: true,
      timestamp: DateTime.now(),
    );

    _messages = [..._messages, userMessage];
    _inputText = '';
    emit(ChatLoaded(messages: _messages, inputText: _inputText));

    // 2. Emit a typing indicator (optional)
    final typingMessage = MessageModel(
      content: 'Typing...',
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    _messages = [..._messages, typingMessage];
    emit(ChatLoaded(messages: _messages, inputText: _inputText));

    // 3. Simulate delay
    await Future.delayed(const Duration(seconds: 2));

    // 4. Remove "Typing..." message
    _messages.removeLast();

    // 5. Random mock response
    final responses = [
      "That's interesting!",
      "Can you explain more?",
      "I see.",
      "Sounds good.",
      "Let me think...",
      "Sure, why not!",
    ];

    final random = Random();
    final randomReply = responses[random.nextInt(responses.length)];

    final botMessage = MessageModel(
      content: randomReply,
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    _messages = [..._messages, botMessage];
    emit(ChatLoaded(messages: _messages, inputText: _inputText));
  }
}

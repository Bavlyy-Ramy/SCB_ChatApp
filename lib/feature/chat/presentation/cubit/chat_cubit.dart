import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:chat_app/feature/chat/data/models/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final Map<String, List<MessageModel>> _userMessages = {};
  String _inputText = '';

  int _messageIdCounter = 0;
  String _generateMessageId() {
    _messageIdCounter++;
    return _messageIdCounter.toString();
  }

  void loadInitialMessages(String userId) {
    _userMessages[userId] = [
      MessageModel(
        id: _generateMessageId(),
        content: 'Hello, how are you?',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      MessageModel(
        id: _generateMessageId(),
        content: 'I\'m fine!',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
      ),
      MessageModel(
        id: _generateMessageId(),
        content: 'What are you doing?',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      MessageModel(
        id: _generateMessageId(),
        content: 'Working',
        isSentByMe: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      MessageModel(
        id: _generateMessageId(),
        content: 'Cool!',
        isSentByMe: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];

    emit(ChatLoaded(
      messagesMap: _userMessages,
      selectedUserId: userId,
      inputText: _inputText,
    ));
  }

  void updateInputText(String value, String userId) {
    _inputText = value;
    emit(ChatLoaded(
      messagesMap: _userMessages,
      selectedUserId: userId,
      inputText: _inputText,
    ));
  }

  Future<void> sendMessage(String userId) async {
    if (_inputText.trim().isEmpty) return;

    final userMessage = MessageModel(
      id: _generateMessageId(),
      content: _inputText.trim(),
      isSentByMe: true,
      timestamp: DateTime.now(),
    );

    _userMessages[userId] = [...?_userMessages[userId], userMessage];
    _inputText = '';

    emit(ChatLoaded(
      messagesMap: _userMessages,
      selectedUserId: userId,
      inputText: _inputText,
    ));

    // Typing indicator
    final typingMessage = MessageModel(
      id: _generateMessageId(),
      content: 'Typing...',
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    _userMessages[userId] = [..._userMessages[userId]!, typingMessage];

    emit(ChatLoaded(
      messagesMap: _userMessages,
      selectedUserId: userId,
      inputText: _inputText,
    ));

    await Future.delayed(const Duration(seconds: 2));
    _userMessages[userId]!.removeLast(); // Remove "Typing..."

    final responses = [
      "to7faa!",
      "Gamed!",
      "La2 La2",
      "Ely t2olo",
      "That's interesting!",
      "ya3am ma4y",
      "Akid ya sa7by",
      "Sounds good.",
      "Let me think...",
      "Sure, why not!",
    ];

    final random = Random();
    final randomReply = responses[random.nextInt(responses.length)];

    final botMessage = MessageModel(
      id: _generateMessageId(),
      content: randomReply,
      isSentByMe: false,
      timestamp: DateTime.now(),
    );

    _userMessages[userId] = [..._userMessages[userId]!, botMessage];

    emit(ChatLoaded(
      messagesMap: _userMessages,
      selectedUserId: userId,
      inputText: _inputText,
    ));
  }

  void sendImageMessage(String userId, String imagePath) {
    final newMessage = MessageModel(
      id: _generateMessageId(),
      imagePath: imagePath,
      isSentByMe: true,
      timestamp: DateTime.now(),
    );

    _userMessages[userId] = [...?_userMessages[userId], newMessage];

    emit(ChatLoaded(
      messagesMap: _userMessages,
      selectedUserId: userId,
      inputText: '',
    ));
  }

  void editMessage(String userId, String messageId, String newText) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedMessages = List<MessageModel>.from(
        currentState.messagesMap[userId] ?? [],
      ).map((msg) {
        return msg.id == messageId
            ? msg.copyWith(text: newText, edited: true)
            : msg;
      }).toList();

      emit(ChatLoaded(
        messagesMap: {
          ...currentState.messagesMap,
          userId: updatedMessages,
        },
        selectedUserId: currentState.selectedUserId,
        inputText: currentState.inputText,
      ));
    }
  }

  void deleteMessage(String userId, String messageId) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      final updatedMessages = (currentState.messagesMap[userId] ?? [])
          .where((msg) => msg.id != messageId)
          .toList();

      emit(ChatLoaded(
        messagesMap: {
          ...currentState.messagesMap,
          userId: updatedMessages,
        },
        selectedUserId: currentState.selectedUserId,
        inputText: currentState.inputText,
      ));
    }
  }
}

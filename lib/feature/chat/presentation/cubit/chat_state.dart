part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoaded extends ChatState {
  final Map<String, List<MessageModel>> messagesMap;
  final String selectedUserId;
  final String inputText;

  ChatLoaded({
    required this.messagesMap,
    required this.selectedUserId,
    required this.inputText,
  });

  /// Helper getter: returns the messages for the currently selected user
  List<MessageModel> get messagesForSelectedUser =>
      messagesMap[selectedUserId] ?? [];
}

final class ChatSuccess extends ChatState {
  final Map<String, List<MessageModel>> messagesMap;
  final String selectedUserId;

  ChatSuccess(this.messagesMap, this.selectedUserId);

  List<MessageModel> get messagesForSelectedUser =>
      messagesMap[selectedUserId] ?? [];
}

final class ChatFailure extends ChatState {
  final String error;

  ChatFailure(this.error);
}

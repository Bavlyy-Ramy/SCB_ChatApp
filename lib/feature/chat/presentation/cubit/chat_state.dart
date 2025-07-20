part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  final String inputText;

  ChatLoaded({
    required this.messages,
    required this.inputText,
  });
}

final class ChatSuccess extends ChatState {
  final List<MessageModel> messages;

  ChatSuccess(this.messages);
}

final class ChatFailure extends ChatState {
  final String error;

  ChatFailure(this.error);
}

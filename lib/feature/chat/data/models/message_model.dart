class MessageModel {
  final String? content;
  final String? imagePath;
  final bool isSentByMe;
  final DateTime timestamp;

  MessageModel({this.imagePath,this.content, required this.isSentByMe, required this.timestamp});

 bool get isImage => imagePath != null && imagePath!.isNotEmpty;
}


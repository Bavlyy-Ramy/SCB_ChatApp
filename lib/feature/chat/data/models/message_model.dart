class MessageModel {
  final String? content;
  final String? imagePath;
  final bool isSentByMe;
  final DateTime timestamp;
  final String id;
   final bool? edited;
  MessageModel({required this.id,  this.edited, this.imagePath,this.content, required this.isSentByMe, required this.timestamp});

 bool get isImage => imagePath != null && imagePath!.isNotEmpty;
 MessageModel copyWith({
    String? text,
    bool? edited,
  }) {
    return MessageModel(
      id: id,
      content: text ?? this.content,
      isSentByMe: isSentByMe,
      timestamp: timestamp,
      edited: edited ?? this.edited,
    );
  }
}


class UserModel {
  final String id;
  final String name;
  final String lastMessage;
  final String imageUrl;
  final String lastSeenTime; // e.g., "3m ago", "5d ago"
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.lastSeenTime,
    required this.isOnline,
  });
}

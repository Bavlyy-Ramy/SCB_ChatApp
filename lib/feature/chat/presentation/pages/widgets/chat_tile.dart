import 'package:chat_app/feature/chat/data/models/user_model.dart';
import 'package:chat_app/feature/chat/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final UserModel user;

  const ChatTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatPage(user: user),
          ),
        );
      },
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(user.imageUrl),
            radius: 25,
          ),
          if (user.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title:
          Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(user.lastMessage, overflow: TextOverflow.ellipsis),
      trailing: Text(user.lastSeenTime),
    );
  }
}

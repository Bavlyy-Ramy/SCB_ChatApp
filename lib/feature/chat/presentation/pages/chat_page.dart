import 'dart:developer';

import 'package:chat_app/feature/chat/data/models/message_model.dart';
import 'package:chat_app/feature/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_app/feature/chat/presentation/pages/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController messageController;
  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child:
                BlocConsumer<ChatCubit, ChatState>(listener: (context, state) {
              if (state is ChatLoaded) {
                _scrollToBottom();
              }
            }, builder: (context, state) {
              if (state is ChatLoaded) {
                final messages = state.messages;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(message: messages[index]);
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          ),
          _buildInputBar(context),
        ],
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppBar(
        backgroundColor: const Color(0xFF00BF6C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/icons/3amy.jpg'),
              minRadius: 26,
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bavly Ramy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Active 3m ago',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    final ChatCubit cubit = context.read<ChatCubit>();

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.3)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.mic, color: Color(0xFF00BF6C)),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: messageController,
                  onChanged: (text) => cubit.updateInputText(text),
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      cubit.sendMessage();
                      messageController.clear();
                      cubit.updateInputText('');
                      FocusScope.of(context).unfocus(); // ✅ Close keyboard
                    }
                  },
                  textInputAction:
                      TextInputAction.send, // changes "Enter" to "Send" icon
                  decoration: InputDecoration(
                    hintText: "Type message",
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF00BF6C)),
                      onPressed: () {
                        if (messageController.text.trim().isNotEmpty) {
                          cubit.sendMessage();
                          messageController.clear();
                          cubit.updateInputText('');
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon:
                  const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
              onPressed: () async {
                final picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.camera);

                if (image != null) {
                  // 🔥 You can now send, preview, or upload this image
                   context.read<ChatCubit>().sendImageMessage(image.path);
                  log("📸 Captured image path: ${image.path}");
                } else {
                  log("❌ No image captured.");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

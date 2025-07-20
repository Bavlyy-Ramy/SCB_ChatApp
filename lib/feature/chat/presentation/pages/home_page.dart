import 'package:chat_app/feature/chat/presentation/cubit/chat_cubit.dart';
import 'package:chat_app/feature/chat/presentation/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return BlocProvider(
                create: (_) => ChatCubit(),
                child: const ChatPage(),
              );
            }),
          );
        },
        child: Text("press to chat"),
      )),
    );
  }
}

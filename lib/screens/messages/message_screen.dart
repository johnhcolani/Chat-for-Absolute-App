import 'package:chat_for_absolute_app/providers/user_provider.dart';
import 'package:chat_for_absolute_app/screens/auth/signin_or_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/ChatMessage.dart';
import 'components/chat_input_field.dart';
import 'components/message_tile.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flutter Dev Chat"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<UserProvider>().signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SigninOrSignupScreen()),
              );
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: ListView.builder(
                itemCount: demeChatMessages.length,
                itemBuilder:
                    (context, index) => MessageTile(
                      message: demeChatMessages[index].text,
                      isSender: index == 1,
                    ),
              ),
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}

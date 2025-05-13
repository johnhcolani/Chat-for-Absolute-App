import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_for_absolute_app/providers/user_provider.dart';
import 'package:chat_for_absolute_app/providers/message_provider.dart';
import 'package:chat_for_absolute_app/screens/auth/signin_or_signup_screen.dart';
import 'package:chat_for_absolute_app/shared/extentions.dart';

import '../../constants.dart';
import 'components/chat_input_field.dart';
import 'components/message_tile.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    super.initState();
    final messageProvider = context.read<MessageProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      messageProvider.getMessages();
      messageProvider.startSubscription();
    });
  }

  @override
  void dispose() {
    context.read<MessageProvider>().disposeSubscription();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.watch<UserProvider>().currentUserId;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flutter Dev Chat"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<UserProvider>().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SigninOrSignupScreen()),
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
              child: Consumer<MessageProvider>(
                builder: (_, messageProvider, __) {
                  if (messageProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (messageProvider.errorMessage != null) {
                    context.showError(messageProvider.errorMessage!);
                    return const Center(child: Text('Error loading messages.'));
                  }
                  if (messageProvider.messages.isEmpty) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: messageProvider.messages.length,
                    itemBuilder: (context, index) {
                      final message = messageProvider.messages[index];
                      return MessageTile(
                        message: message,
                        isSender: message.userId == currentUserId,
                      );
                    },
                  );
                },
              ),
            ),
          ),
          const ChatInputField(),
        ],
      ),
    );
  }
}

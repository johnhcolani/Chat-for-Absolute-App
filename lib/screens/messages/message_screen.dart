import 'dart:async';

import 'package:chat_for_absolute_app/providers/user_provider.dart';
import 'package:chat_for_absolute_app/screens/auth/signin_or_signup_screen.dart';
import 'package:chat_for_absolute_app/shared/extentions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/ChatMessage.dart';
import '../../providers/message_provider.dart';
import 'components/chat_input_field.dart';
import 'components/message_tile.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late StreamSubscription _messageSubscription;
  @override
  void initState() {
    getMessages();
    super.initState();
  }

  void getMessages() async {
    final messageProvider = context.read<MessageProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      messageProvider.getMessages();
      _messageSubscription = messageProvider.getMessagesStream().listen((
        response,
      ) {
        if (response.data != null) {
           messageProvider.addMessage(response.data!);

        } else if (response.hasErrors) {
          context.showError(response.errors.first.message);
        }
      });
    });
  }
@override
  void dispose() {
    _messageSubscription.cancel();
    super.dispose();
  }
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
              child: Consumer<MessageProvider>(
                builder: (_, messageProvider, _) {
                  if (messageProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (messageProvider.errorMessage != null) {
                    context.showError(messageProvider.errorMessage!);
                    return Center(child: Text('Error'));
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: messageProvider.messages.length,
                    itemBuilder:
                        (context, index) => MessageTile(
                          message: messageProvider.messages[index],
                          isSender: false,
                        ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

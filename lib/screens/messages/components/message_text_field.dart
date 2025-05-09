import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:chat_for_absolute_app/models/Message.dart';
import 'package:chat_for_absolute_app/providers/message_provider.dart';
import 'package:chat_for_absolute_app/shared/extentions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/message_provider.dart';
import '../../../providers/user_provider.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField({super.key});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  late final TextEditingController _messageController;
  late AuthUser _currentUser;

  @override
  void initState() {
    _messageController = TextEditingController();
    _currentUser = context.read<UserProvider>().currentUser!;
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        controller: _messageController,
        textInputAction: TextInputAction.send,
        onFieldSubmitted: (value) async {
          if (value.isNotEmpty) {
            final message = Message(
              userId: _currentUser.userId,
              username: _currentUser.username,
              message: _messageController.text,
              type: "Message",
              createdAt: DateTime.now().toString(),
            );
            final response = await context.read<MessageProvider>().sendMessage(message);
            response.fold(
                (error) => context.showError(error),
                (resMessage){
                  if(resMessage != null){
                    _messageController.clear();
                  }
                }
            );
          }
        },
        decoration: InputDecoration(
          hintText: "Type message",
          border: InputBorder.none,
        ),
      ),
    );
  }
}

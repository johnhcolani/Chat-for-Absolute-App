import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import '../../../constants.dart';
import '../../../models/Message.dart';
import '../../../providers/message_provider.dart';

class MessageTextField extends StatefulWidget {
  const MessageTextField({Key? key}) : super(key: key);

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();

      final email = attributes
          .firstWhere((a) => a.userAttributeKey.key == 'email')
          .value;

      final message = Message(
        userId: currentUser.userId,
        username: email,
        message: text,
        type: 'text',
        createdAt: DateTime.now().toIso8601String(),
      );

      final result =
      await context.read<MessageProvider>().sendMessage(message);

      result.fold(
            (error) => print("❌ Failed to send: $error"),
            (success) =>
            print("✅ Sent message ID: ${success?.id ?? '[unknown]'}"),
      );

      _controller.clear();
    } catch (e) {
      print("❌ Error creating message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.send,
      onSubmitted: (_) => _sendMessage(),
      decoration: const InputDecoration(
        hintText: "Type your message...",
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(defaultPadding),
      ),
    );
  }
}

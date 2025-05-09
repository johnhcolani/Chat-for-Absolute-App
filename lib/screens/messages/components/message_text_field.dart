import 'package:flutter/material.dart';
class MessageTextField extends StatefulWidget {
  const MessageTextField({
    super.key,
  });

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    _messageController = TextEditingController();
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
        onFieldSubmitted: (value){},
        decoration: InputDecoration(
          hintText: "Type message",
          border: InputBorder.none,
        ),
      ),
    );
  }
}
